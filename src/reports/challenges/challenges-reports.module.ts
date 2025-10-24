import { Module } from "@nestjs/common";
import { SqlLoaderService } from "src/common/sql-loader.service";
import { ChallengesReportsController } from "./challenges-reports.controller";
import { ChallengesReportsService } from "./challenges-reports.service";

@Module({
  controllers: [ChallengesReportsController],
  providers: [ChallengesReportsService, SqlLoaderService],
})
export class ChallengesReportsModule {}
