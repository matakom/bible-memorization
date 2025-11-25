/* eslint-disable prettier/prettier */
import { Controller, Post, Body, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { GetUser } from '../auth/get-user.decorator';
import { User } from '../user/user.entity';
import { PracticeService, PracticeResultDto } from './practice.service';

@Controller('practice')
@UseGuards(AuthGuard('jwt'))
export class PracticeController {
    constructor(private practiceService: PracticeService) { }

    @Post('submit')
    async submitPractice(
        @GetUser() user: User,
        @Body() results: PracticeResultDto[],
    ): Promise<void> {
        return this.practiceService.processSession(user, results);
    }
}