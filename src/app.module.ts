import { MiddlewareConsumer, Module, NestModule } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { DbModule } from "./db/db.module";
import { AuthMiddleware } from "./auth/auth.middleware";
import { HealthModule } from "./health/health.module";

import { TopgearReportsModule } from "./topgear-reports/topgear-reports.module";
import { StatisticsModule } from "./statistics/statistics.module";
import { SfdcReportsModule } from "./sfdc-reports/sfdc-reports.module";

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    DbModule,
    TopgearReportsModule,
    StatisticsModule,
    SfdcReportsModule,
    HealthModule,
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    // Apply the AuthMiddleware to all routes in the application.
    consumer.apply(AuthMiddleware).forRoutes("*");
  }
}
