import { Injectable } from "@nestjs/common";
import * as fs from "fs";
import * as path from "path";

/**
 * Serves SRM statistics from checked-in JSON snapshots.
 *
 * These endpoints intentionally do not query `memberStats` or
 * `memberStatsHistory` live. The files under `data/statistics/srm` are static
 * report artifacts that can be refreshed independently from the API runtime.
 */
@Injectable()
export class SrmDataService {
  private baseDir = path.resolve(process.cwd(), "data/statistics/srm");

  /**
   * Load an SRM statistics snapshot from disk.
   * @param fileName snapshot file name under `data/statistics/srm`
   * @returns parsed JSON payload exposed by the statistics endpoints
   */
  private loadJson<T = any>(fileName: string): T {
    const fullPath = path.join(this.baseDir, fileName);
    const raw = fs.readFileSync(fullPath, "utf-8");
    return JSON.parse(raw) as T;
  }

  /**
   * Get the highest-rated SRM snapshot.
   * @returns parsed contents of `highest-rated.json`
   */
  getTopRated() {
    return this.loadJson("highest-rated.json");
  }

  /**
   * Get the SRM country ratings snapshot.
   * @returns parsed contents of `country-ratings.json`
   */
  getCountryRatings() {
    return this.loadJson("country-ratings.json");
  }

  /**
   * Get the SRM competitions-count snapshot.
   * @returns parsed contents of `competitions-count.json`
   */
  getCompetitionsCount() {
    return this.loadJson("competitions-count.json");
  }
}
