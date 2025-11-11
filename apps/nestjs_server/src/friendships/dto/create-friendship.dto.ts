/* eslint-disable prettier/prettier */
import { IsString, Length, IsNotEmpty } from 'class-validator';

export class CreateFriendshipDto {
    @IsString()
    @IsNotEmpty()
    @Length(6, 6, { message: 'Friend code must be exactly 6 characters long' })
    readonly friendCode: string;
}