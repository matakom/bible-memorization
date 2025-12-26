/* eslint-disable prettier/prettier */
import { IsDateString, IsOptional, IsArray, IsObject } from 'class-validator';

export class SyncPullQueryDto {
    @IsOptional()
    @IsDateString()
    lastSync?: string; // e.g. "2025-11-01T10:00:00Z"
}

export class SyncPushDto {
    @IsOptional()
    @IsArray()
    verses?: any[];

    @IsOptional()
    @IsArray()
    exercises?: any[];

    @IsOptional()
    @IsArray()
    friendships?: any[];

    @IsOptional()
    @IsObject()
    user?: {
        language?: string;
    };
}