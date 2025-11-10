/* eslint-disable prettier/prettier */
import {
    Controller,
    Patch,
    Body,
    UsePipes,
    ValidationPipe,
    UseGuards,
    Get,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { UserService } from './user.service';
import { UpdateSettingsDto } from './dto/update-settings.dto';
import { GetUser } from '../auth/get-user.decorator';
import { User } from './user.entity';

@Controller('user')
export class UserController {
    constructor(private readonly userService: UserService) { }

    @Patch('settings')
    @UseGuards(AuthGuard('jwt'))
    @UsePipes(new ValidationPipe({ whitelist: true }))
    async updateUserSettings(
        @Body() updateSettingsDto: UpdateSettingsDto,
        @GetUser() user: User,
    ) {
        const { theme, locale } = updateSettingsDto;

        return this.userService.updateUserSettings(
            user.id,
            theme,
            locale,
        );
    }

    @Get('settings')
    @UseGuards(AuthGuard('jwt'))
    async getUserSettings(
        @GetUser() user: User
    ) {
        return this.userService.getUserSettings(user.id);
    }
}