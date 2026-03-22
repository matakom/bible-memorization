/* eslint-disable prettier/prettier */
import { IsString, IsInt, IsNotEmpty, Min } from 'class-validator';

export class CreateVerseDto {
    @IsString()
    @IsNotEmpty()
    readonly book: number;

    @IsInt()
    @Min(1)
    readonly chapter: number;

    @IsInt()
    @Min(1)
    readonly verse: number;

    @IsString()
    @IsNotEmpty()
    readonly translation: string;

    @IsString()
    @IsNotEmpty()
    readonly text: string;

}