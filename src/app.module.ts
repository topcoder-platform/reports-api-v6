import { MiddlewareConsumer, Module, NestModule } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { DbModule } from "./db/db.module";
import { AuthMiddleware } from "./auth/auth.middleware";
import { HealthModule } from "./health/health.module";

import { TopgearReportsModule } from "./reports/topgear/topgear-reports.module";
import { SfdcReportsModule } from "./reports/sfdc/sfdc-reports.module";
import { ChallengesReportsModule } from "./reports/challenges/challenges-reports.module";

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    DbModule,
    TopgearReportsModule,
    SfdcReportsModule,
    ChallengesReportsModule,
    HealthModule,
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    // Apply the AuthMiddleware to all routes in the application.
    consumer.apply(AuthMiddleware).forRoutes("*");
  }
}
