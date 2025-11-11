/* eslint-disable prettier/prettier */
import {
    Controller,
    Post,
    Body,
    UsePipes,
    ValidationPipe,
    UseGuards
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { GetUser } from '../auth/get-user.decorator';
import { User } from '../user/user.entity';
import { CreateFriendshipDto } from './dto/create-friendship.dto';
import { FriendshipsService } from './friendships.service';
import { Friendship } from './friendships.entity';

@Controller('friendships')
@UseGuards(AuthGuard('jwt'))
export class FriendshipsController {
    constructor(private readonly friendshipsService: FriendshipsService) { }

    @Post()
    @UseGuards(AuthGuard('jwt'))
    @UsePipes(new ValidationPipe({ whitelist: true }))
    async createFriendRequest(
        @Body() createFriendshipDto: CreateFriendshipDto,
        @GetUser() user: User,
    ): Promise<Friendship> {
        return this.friendshipsService.createRequest(createFriendshipDto, user);
    }
}