import { MiddlewareConsumer, Module, NestModule } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { DbModule } from "./db/db.module";
import { AuthMiddleware } from "./auth/auth.middleware";
import { HealthModule } from "./health/health.module";

import { TopgearReportsModule } from "./reports/topgear/topgear-reports.module";
import { TopcoderReportsModule } from "./reports/topcoder/topcoder-reports.module";
import { StatisticsModule } from "./statistics/statistics.module";
import { SfdcReportsModule } from "./reports/sfdc/sfdc-reports.module";
import { ChallengesReportsModule } from "./reports/challenges/challenges-reports.module";
import { IdentityReportsModule } from "./reports/identity/identity-reports.module";
import { ReportsModule } from "./reports/reports.module";
import { MemberSearchModule } from "./reports/member/member-search.module";

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    DbModule,
    TopgearReportsModule,
    TopcoderReportsModule,
    StatisticsModule,
    SfdcReportsModule,
    ChallengesReportsModule,
    IdentityReportsModule,
    ReportsModule,
    MemberSearchModule,
    HealthModule,
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    // Apply the AuthMiddleware to all routes in the application.
    consumer.apply(AuthMiddleware).forRoutes("*");
  }
}
