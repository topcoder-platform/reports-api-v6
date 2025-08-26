import { Injectable, INestApplication, OnModuleDestroy, OnModuleInit } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { Pool } from "pg";

@Injectable()
export class DbService implements OnModuleInit, OnModuleDestroy {
  private pool: Pool;

  constructor(private readonly config: ConfigService) {
    const connectionString = this.config.get<string>("DATABASE_URL", "");
    this.pool = new Pool({ connectionString });
  }

  async onModuleInit() {
    await this.pool.query("SELECT 1"); // simple readiness check
  }

  async onModuleDestroy() {
    await this.pool.end();
  }

  // Run a parametrized SQL (from file), with $1, $2… placeholders.
  async query<T = any>(sql: string, params: any[] = []): Promise<T[]> {
    const result = await this.pool.query(sql, params);
    return result.rows as T[];
  }
  
  enableShutdownHooks(app: INestApplication) {
    process.on('beforeExit', () => {
      app.close().catch(console.error);
    });
  }
}
