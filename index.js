import * as path from "path";
import * as fs from "fs";
import { FlightRadar24API } from "flightradarapi";

import { ensureDataDir } from "./modules/utils.js";
import { generateRetinaMap } from "./modules/map.js";

const folderName = "data";

const frApi = new FlightRadar24API();
const output = [];

const R = 6371; // Radius of the Earth in km
const side = 800; // Size of the grid side in km

// Function to convert distance in km to degrees
const kmToDegrees = km => km / ((Math.PI * R) / 180);

// Size of the grid in degrees
const sideDegrees = kmToDegrees(side);
// Initial coordinates
const initialLat = 90; // North
const initialLng = -180; // West

// Initial coordinates and limits
const minLat = -90;
const maxLat = 90;
const minLng = -180;
const maxLng = 180;

let features = [];
let row = 0;

let createGridFile = false;

async function main() {
  await ensureDataDir(folderName);
  console.log(`Starting the job...`);

  // Iterate over each cell of the grid
  for (let lat = initialLat; lat > -90; lat -= sideDegrees) {
    let col = 0;
    for (let lng = initialLng; lng < 180; lng += sideDegrees) {
      const tl_y = Math.min(lat, maxLat);
      const tl_x = Math.max(lng, minLng);
      const br_y = Math.max(lat - sideDegrees, minLat);
      const br_x = Math.min(lng + sideDegrees, maxLng);
      const bbox = {
        tl_y,
        tl_x,
        br_y,
        br_x,
      };
      //   await wait(110);
      await fetchData(bbox, row, col);
      if (createGridFile === true) {
        addFeature(bbox, row, col);
      }
      col++;
    }
    row++;
  }
  if (createGridFile === true) {
    writeGrid();
  }
}
function addFeature(bbox, row, col) {
  features.push({
    type: "Feature",
    geometry: {
      type: "Polygon",
      coordinates: [
        [
          [bbox.tl_x, bbox.tl_y], // Top-left
          [bbox.br_x, bbox.tl_y], // Top-right
          [bbox.br_x, bbox.br_y], // Bottom-right
          [bbox.tl_x, bbox.br_y], // Bottom-left
          [bbox.tl_x, bbox.tl_y], // Closing the polygon
        ],
      ],
    },
    properties: {
      row: row,
      col: col,
    },
  });
}

async function fetchData({ tl_y, tl_x, br_y, br_x }, row, col) {
  console.log(`Fetching data from row ${row} and col ${col}`);
  let bounds = frApi.getBounds({ tl_y, tl_x, br_y, br_x });
  let flights = await frApi.getFlights(null, bounds);
  if (flights.length > 0) {
    output.push(...flights);
  }
}

const startTime = Date.now();
await main().then(writeData);
logTime(startTime);

function logTime(startTime) {
  const endTime = Date.now(); // End time
  const executionTimeMs = endTime - startTime; // Execution time in milliseconds
  const executionTimeSec = executionTimeMs / 1000; // Execution time in seconds

  // Format the execution time
  let formattedTime;
  if (executionTimeSec > 60) {
    const minutes = Math.floor(executionTimeSec / 60);
    const seconds = Math.floor(executionTimeSec % 60);
    formattedTime = `${minutes} minute${minutes > 1 ? "s" : ""} and ${seconds} second${seconds !== 1 ? "s" : ""}`;
  } else {
    formattedTime = `${Math.floor(executionTimeSec)} second${Math.floor(executionTimeSec) !== 1 ? "s" : ""}`;
  }
  console.log(`Execution Time: ${formattedTime}`);
}

function writeGrid() {
  // Create the GeoJSON object
  const geoJsonData = {
    type: "FeatureCollection",
    features: features,
  };
  fs.writeFile(
    `grid_${side}.geojson`,
    JSON.stringify(geoJsonData),
    "utf8",
    err => {
      if (err) {
        console.error("Error writing file:", err);
      } else {
        console.log(`grid_${side}.geojson created successfully.`);
      }
    }
  );
}

function wait(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function writeData() {
  const asGeoJSON = toGeoJSON(output);
  const timeStamp = new Date().getTime();
  const outputFile = path.join(folderName, `all_${timeStamp}.json`);
  const finalJson = JSON.stringify(asGeoJSON, null, 2);
  fs.writeFile(outputFile, finalJson, "utf8", err => {
    if (err) {
      console.error("Error writing file:", err);
    } else {
      console.log(`File ${outputFile} created successfully.`);
    }
  });
  generateRetinaMap(asGeoJSON, timeStamp);
}

function toGeoJSON(data) {
  return {
    type: "FeatureCollection",
    features: data.map(point => {
      return {
        type: "Feature",
        properties: point,
        geometry: {
          coordinates: [point.longitude, point.latitude],
          type: "Point",
        },
      };
    }),
  };
}

function processZones(zones, parentZone = "") {
  let features = [];

  for (const zoneKey in zones) {
    if (zones.hasOwnProperty(zoneKey) && zoneKey !== "version") {
      const zone = zones[zoneKey];
      const { tl_y, tl_x, br_y, br_x, subzones } = zone;

      const feature = {
        type: "Feature",
        properties: {
          name: parentZone ? `${parentZone} - ${zoneKey}` : zoneKey,
        },
        geometry: {
          type: "Polygon",
          coordinates: [createPolygon(tl_y, tl_x, br_y, br_x)],
        },
      };

      features.push(feature);

      if (subzones) {
        features = features.concat(processZones(subzones, zoneKey));
      }
    }
  }

  return features;
}

function createPolygon(tl_y, tl_x, br_y, br_x) {
  return [
    [tl_x, tl_y], // Top-left
    [br_x, tl_y], // Top-right
    [br_x, br_y], // Bottom-right
    [tl_x, br_y], // Bottom-left
    [tl_x, tl_y], // Closing the polygon
  ];
}

function writeBoundingBoxes() {
  const geoJson = {
    type: "FeatureCollection",
    features: processZones(allZones),
  };
  fs.writeFile(
    "bounding_boxes.geojson",
    JSON.stringify(geoJson),
    "utf8",
    err => {
      if (err) {
        console.error("Error writing file:", err);
      } else {
        console.log(`File created successfully.`);
      }
    }
  );
}
