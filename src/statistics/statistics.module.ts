import { Module } from "@nestjs/common";
import { StatisticsController } from "./statistics.controller";
import { SrmDataService } from "./srm-data.service";
import { MmDataService } from "./mm-data.service";
import { StatisticsGeneralController } from "./statistics-general.controller";
import { GeneralStatisticsService } from "./general-statistics.service";
import { StatisticsDesignController } from "./statistics-design.controller";
import { DesignStatisticsService } from "./design-statistics.service";
import { StatisticsDevelopmentController } from "./statistics-development.controller";
import { DevelopmentStatisticsService } from "./development-statistics.service";
import { StatisticsQaController } from "./statistics-qa.controller";
import { QaStatisticsService } from "./qa-statistics.service";
import { StatisticsExpertSkillsController } from "./statistics-expert-skills.controller";
import { ExpertSkillsStatisticsService } from "./expert-skills-statistics.service";
import { StandardizedSkillsClient } from "./standardized-skills.client";
import { SqlLoaderService } from "../common/sql-loader.service";

@Module({
  controllers: [
    StatisticsController,
    StatisticsGeneralController,
    StatisticsDesignController,
    StatisticsDevelopmentController,
    StatisticsQaController,
    StatisticsExpertSkillsController,
  ],
  providers: [
    SrmDataService,
    MmDataService,
    GeneralStatisticsService,
    DesignStatisticsService,
    DevelopmentStatisticsService,
    QaStatisticsService,
    ExpertSkillsStatisticsService,
    StandardizedSkillsClient,
    SqlLoaderService,
  ],
})
export class StatisticsModule {}
