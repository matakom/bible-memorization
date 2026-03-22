/* eslint-disable prettier/prettier */
import { IsString, IsOptional, IsIn } from 'class-validator';

export class UpdateSettingsDto {
    @IsString()
    @IsIn(['en', 'cs'])
    @IsOptional()
    readonly locale?: string;
}