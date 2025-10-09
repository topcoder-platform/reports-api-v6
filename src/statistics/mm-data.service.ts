import { Injectable } from "@nestjs/common";
import * as fs from "fs";
import * as path from "path";

@Injectable()
export class MmDataService {
  private baseDir = path.resolve(process.cwd(), "data/statistics/mm");

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

  getTop10Finishes() {
    return this.loadJson("top-10-finishes.json");
  }

  getCompetitionsCount() {
    return this.loadJson("competitions-count.json");
  }
}

