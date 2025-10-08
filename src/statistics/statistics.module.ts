import { Module } from "@nestjs/common";
import { StatisticsController } from "./statistics.controller";
import { SrmDataService } from "./srm-data.service";
import { StatisticsGeneralController } from "./statistics-general.controller";
import { GeneralStatisticsService } from "./general-statistics.service";
import { StatisticsDesignController } from "./statistics-design.controller";
import { DesignStatisticsService } from "./design-statistics.service";
import { SqlLoaderService } from "../common/sql-loader.service";

@Module({
  controllers: [
    StatisticsController,
    StatisticsGeneralController,
    StatisticsDesignController,
  ],
  providers: [
    SrmDataService,
    GeneralStatisticsService,
    DesignStatisticsService,
    SqlLoaderService,
  ],
})
export class StatisticsModule {}
