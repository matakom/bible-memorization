/* eslint-disable prettier/prettier */
import {
    Controller,
    Body,
    UseGuards,
    Get,
    Param,
    NotFoundException,
    Query,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { UserService } from './user.service';
import { GetUser } from '../auth/get-user.decorator';
import { User } from './user.entity';
import { UserStatsDto } from './dto/user-stats.dto';

@Controller('user')
export class UserController {
    constructor(private readonly userService: UserService) { }

    @Get('lookup')
    async lookupFriend(@Query('friendCode') friendCode: string) {
        if (!friendCode) {
            throw new NotFoundException("Friend code is required");
        }

        const user = await this.userService.findByFriendCode(friendCode);

        if (!user) {
            throw new NotFoundException('User not found');
        }

        return {
            id: user.id,
            firstName: user.firstName,
            lastName: user.lastName,
        };
    }

    @Get()
    @UseGuards(AuthGuard('jwt'))
    getUser(
        @GetUser() user: User
    ) {
        return user;
    }

    @Get(':id/stats')
    @UseGuards(AuthGuard('jwt'))
    async getFriendStats(@Param('id') friendId: string, @GetUser() user: User): Promise<UserStatsDto> {
        return this.userService.getFriendStats(user.id, friendId);
    }
}