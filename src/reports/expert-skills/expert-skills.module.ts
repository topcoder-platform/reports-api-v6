import { Module } from "@nestjs/common";
import { ExpertSkillsController } from "./expert-skills.controller";
import { ExpertSkillsService } from "./expert-skills.service";
import { ExpertSkillsGuard } from "./guards/expert-skills.guard";
import { StandardizedSkillsClient } from "./standardized-skills.client";

@Module({
  controllers: [ExpertSkillsController],
  providers: [ExpertSkillsService, ExpertSkillsGuard, StandardizedSkillsClient],
})
export class ExpertSkillsModule {}
