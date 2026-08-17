import { Transform } from "class-transformer";
import { IsEnum, IsNotEmpty, IsOptional, IsString } from "class-validator";

export enum CampusChallengeFilter {
  All = "all",
  Public = "public",
  Campus = "campus",
}

export class CampusLeaderboardQueryDto {
  @Transform(({ value }) => (typeof value === "string" ? value.trim() : value))
  @IsString()
  @IsNotEmpty()
  groupName!: string;

  @Transform(({ value }) =>
    typeof value === "string" ? value.trim().toLowerCase() : value,
  )
  @IsOptional()
  @IsEnum(CampusChallengeFilter)
  challengeFilter?: CampusChallengeFilter;
}
