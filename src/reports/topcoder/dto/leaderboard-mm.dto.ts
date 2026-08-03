import { Transform } from "class-transformer";
import { IsArray, IsNotEmpty, IsNumber, IsOptional, IsString } from "class-validator";

export class LeaderboardMmQueryDto {
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

  @Transform(({ value }) => {
    if (typeof value === "string") {
      return value
        .split(",")
        .map((item) => Number(item.trim()))
        .filter((item) => Number.isFinite(item));
    }
    return value;
  })
  @IsOptional()
  @IsArray()
  @IsNumber({}, { each: true })
  placementPoints?: number[];

  @Transform(({ value }) => (typeof value === "string" ? Number(value) : value))
  @IsOptional()
  @IsNumber()
  defaultPlacementPoints?: number;

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
  writersAndTesters?: string[];
}
