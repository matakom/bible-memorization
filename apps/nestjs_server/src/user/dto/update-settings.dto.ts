/* eslint-disable prettier/prettier */
import { IsString, IsOptional, IsIn } from 'class-validator';

export class UpdateSettingsDto {
    @IsString()
    @IsIn(['light', 'dark', 'system'])
    @IsOptional()
    readonly theme?: string;

    @IsString()
    @IsIn(['en', 'cs'])
    @IsOptional()
    readonly locale?: string;
}