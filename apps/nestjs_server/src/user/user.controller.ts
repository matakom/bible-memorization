/* eslint-disable prettier/prettier */
import {
    Controller,
    UseGuards,
    Get,
    Post,
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

@Controller('user')
export class UserController {
    constructor(private readonly userService: UserService) { }

    @Post('login')
    @UseGuards(AuthGuard('jwt-login'))
    loginUser(@GetUser() user: User) {
        return user;
    }

    @Get('lookup')
    async lookupFriend(@Query('friendCode') friendCode: string) {
        if (!friendCode) {
            throw new NotFoundException();
        }

        const user = await this.userService.findByFriendCode(friendCode);

        if (!user) {
            throw new NotFoundException();
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
    @UseGuards(AuthGuard('jwt'))
    async deleteAccount(@Req() req) {
        const userId = req.user.id;
        return this.userService.deleteUserFully(userId);
    }
}