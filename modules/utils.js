import { fileURLToPath } from "url";
import * as path from "path";
import { dirname } from "path";
import * as fs from "fs";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Function to create the folder if it does not exist
export async function ensureDataDir(dataDirName, rootFolder = false) {
  if (rootFolder === true) {
    const dataDir = path.join(process.cwd(), dataDirName);
    if (!fs.existsSync(dataDir)) {
      fs.mkdirSync(dataDir);
    }
  } else {
    const dataDir = path.join(__dirname, dataDirName);
    if (!fs.existsSync(dataDir)) {
      fs.mkdirSync(dataDir);
    }
  }
}
