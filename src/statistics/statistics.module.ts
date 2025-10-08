import { Module } from "@nestjs/common";
import { StatisticsController } from "./statistics.controller";
import { SrmDataService } from "./srm-data.service";
import { StatisticsGeneralController } from "./statistics-general.controller";
import { GeneralStatisticsService } from "./general-statistics.service";
import { SqlLoaderService } from "../common/sql-loader.service";

@Module({
  controllers: [StatisticsController, StatisticsGeneralController],
  providers: [SrmDataService, GeneralStatisticsService, SqlLoaderService],
})
export class StatisticsModule {}
