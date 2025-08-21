import { Injectable } from "@nestjs/common";
import * as fs from "fs";
import * as path from "path";

@Injectable()
export class SqlLoaderService {
  private cache = new Map<string, string>();
  private readonly baseDir = path.resolve(process.cwd(), "sql");

  load(relativePath: string): string {
    const key = path.normalize(relativePath);
    if (this.cache.has(key)) return this.cache.get(key)!;

    const absolute = path.join(this.baseDir, key);
    const sql = fs.readFileSync(absolute, "utf8");
    this.cache.set(key, sql);
    return sql;
  }
}
