import { Injectable } from "@nestjs/common";
import * as fs from "fs";
import * as path from "path";

/**
 * Serves Marathon Match statistics from checked-in JSON snapshots.
 *
 * These endpoints intentionally do not query `memberStats` or
 * `memberStatsHistory` live. The files under `data/statistics/mm` are static
 * report artifacts that can be refreshed independently from the API runtime.
 */
@Injectable()
export class MmDataService {
  private baseDir = path.resolve(process.cwd(), "data/statistics/mm");

  /**
   * Load a Marathon Match statistics snapshot from disk.
   * @param fileName snapshot file name under `data/statistics/mm`
   * @returns parsed JSON payload exposed by the statistics endpoints
   */
  private loadJson<T = any>(fileName: string): T {
    const fullPath = path.join(this.baseDir, fileName);
    const raw = fs.readFileSync(fullPath, "utf-8");
    return JSON.parse(raw) as T;
  }

  /**
   * Get the highest-rated Marathon Match snapshot.
   * @returns parsed contents of `highest-rated.json`
   */
  getTopRated() {
    return this.loadJson("highest-rated.json");
  }

  /**
   * Get the Marathon Match country ratings snapshot.
   * @returns parsed contents of `country-ratings.json`
   */
  getCountryRatings() {
    return this.loadJson("country-ratings.json");
  }

  /**
   * Get the Marathon Match top-10 finishes snapshot.
   * @returns parsed contents of `top-10-finishes.json`
   */
  getTop10Finishes() {
    return this.loadJson("top-10-finishes.json");
  }

  /**
   * Get the Marathon Match competitions-count snapshot.
   * @returns parsed contents of `competitions-count.json`
   */
  getCompetitionsCount() {
    return this.loadJson("competitions-count.json");
  }
}
