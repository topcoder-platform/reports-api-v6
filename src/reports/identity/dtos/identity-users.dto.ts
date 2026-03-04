import { ApiProperty } from "@nestjs/swagger";
import { Type } from "class-transformer";
import {
  ArrayNotEmpty,
  IsArray,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
} from "class-validator";

/**
 * Query filters for exporting users by role.
 */
export class UsersByRoleQueryDto {
  @ApiProperty({ required: false })
  @IsOptional()
  @IsInt()
  @Type(() => Number)
  roleId?: number;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  roleName?: string;
}

/**
 * Query filters for exporting users by security group.
 */
export class UsersByGroupQueryDto {
  @ApiProperty({ required: false })
  @IsOptional()
  @IsNumber()
  @Type(() => Number)
  groupId?: number;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  groupName?: string;
}

/**
 * Shared identity user payload returned by identity report endpoints.
 */
export interface IdentityUserDto {
  userId: number | null;
  handle: string;
  email: string | null;
  country: string | null;
}

/**
 * Request payload for exporting users by handle list.
 */
export class UsersByHandlesBodyDto {
  @ApiProperty({ type: [String], required: true })
  @IsArray()
  @ArrayNotEmpty()
  @IsString({ each: true })
  handles!: string[];
}
