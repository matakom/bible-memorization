/* eslint-disable prettier/prettier */
import {
    Controller,
    Body,
    UseGuards,
    Get,
    Param,
    NotFoundException,
    Query,
    Delete,
    Req,
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

        console.log('code ', friendCode);

        const user = await this.userService.findByFriendCode(friendCode);
        console.log('user ', user.email);

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
    async getUserStats(@Param('id') id: string) {
        return this.userService.getUserStats(id);
    }

    @Delete('me')
    @UseGuards(AuthGuard())
    async deleteAccount(@Req() req) {
        const userId = req.user.id;
        return this.userService.deleteUserFully(userId);
    }
}