import { Injectable } from "@nestjs/common";
import * as fs from "fs";
import * as path from "path";

@Injectable()
export class SrmDataService {
  private baseDir = path.resolve(process.cwd(), "data/statistics/srm");

  private loadJson<T = any>(fileName: string): T {
    const fullPath = path.join(this.baseDir, fileName);
    const raw = fs.readFileSync(fullPath, "utf-8");
    return JSON.parse(raw) as T;
  }

  getTopRated() {
    return this.loadJson("highest-rated.json");
  }

  getCountryRatings() {
    return this.loadJson("country-ratings.json");
  }

  getCompetitionsCount() {
    return this.loadJson("competitions-count.json");
  }
}

