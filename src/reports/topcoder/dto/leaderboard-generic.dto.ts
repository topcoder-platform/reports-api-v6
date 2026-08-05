import { Transform } from "class-transformer";
import { IsArray, IsBoolean, IsNotEmpty, IsNumber, IsOptional, IsString } from "class-validator";

export class LeaderboardGenericQueryDto {
  @Transform(({ value }) => {
    if (typeof value === "string") {
      return value
        .split(",")
        .map((item) => item.trim())
        .filter(Boolean);
    }
    return value;
  })
  @IsArray()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  challengeIds!: string[];

  @Transform(({ value }) => (typeof value === "string" ? Number(value) : value))
  @IsOptional()
  @IsNumber()
  pointsPerDay?: number;

  @Transform(({ value }) => {
    if (typeof value === "string") {
      return value
        .split(",")
        .map((item) => item.trim())
        .filter(Boolean);
    }
    return value;
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  placementPrizeAmounts?: string[];

  @Transform(({ value }) => value === "true" || value === true)
  @IsOptional()
  @IsBoolean()
  showHeadingAndSubtitle?: boolean;
}
