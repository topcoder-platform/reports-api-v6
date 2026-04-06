import { Module } from "@nestjs/common";
import { MemberSearchController } from "./member-search.controller";
import { MemberSearchService } from "./member-search.service";
import { MemberSearchGuard } from "./guards/member-search.guard";

@Module({
  controllers: [MemberSearchController],
  providers: [MemberSearchService, MemberSearchGuard],
})
export class MemberSearchModule {}
