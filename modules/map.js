import * as path from "path";
import * as fs from "fs";
import { createCanvas } from "canvas";
import * as d3 from "d3";
import * as d3Geo from "d3-geo";
import * as topojson from "topojson-client";
import geoData from "./50m.json" assert { type: "json" };

const folderName = "images";
import { ensureDataDir } from "./utils.js";

export async function generateRetinaMap(flightsData, timeStamp) {
  await ensureDataDir(folderName);
  const outline = { type: "Sphere" };
  const width = 800 * 2;
  const height = 400 * 2;
  const devicePixelRatio = 2;

  const land = topojson.feature(geoData, geoData.objects.land);
  const borders = topojson.mesh(
    geoData,
    geoData.objects.countries,
    (a, b) => a !== b
  );
  const projection = d3Geo.geoEqualEarth().fitSize([width, height], outline);

  // Crear el canvas y el contexto
  const canvas = createCanvas(
    width * devicePixelRatio,
    height * devicePixelRatio
  );

  const context = canvas.getContext("2d");

  context.scale(devicePixelRatio, devicePixelRatio);

  const pathGeo = d3.geoPath(projection, context);

  context.fillStyle = "#ffffff";
  context.fillRect(0, 0, width, height);
  context.fill();

  context.beginPath(),
    pathGeo(land),
    (context.fillStyle = "#eee"),
    context.fill(),
    context.beginPath(),
    pathGeo(borders),
    (context.strokeStyle = "#fff"),
    (context.lineWidth = 1),
    context.stroke();

  context.fillStyle = "#ff5500";
  flightsData.features.forEach(feature => {
    const [x, y] = projection(feature.geometry.coordinates);
    context.beginPath();
    context.fillRect(x, y, 1, 1);
    context.fill();
  });

  await ensureDataDir(folderName, true);

  const outputFile = path.join(folderName, `./world_map_${timeStamp}.jpg`);
  const out = fs.createWriteStream(outputFile);
  const stream = canvas.createJPEGStream();
  stream.pipe(out);
  out.on("finish", () =>
    console.log(`File ./world_map_${timeStamp}.jpg saved`)
  );
}
