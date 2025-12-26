/* eslint-disable prettier/prettier */
import { Controller, Get, Post, Body, Query, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { GetUser } from '../auth/get-user.decorator';
import { User } from '../user/user.entity';
import { SyncService } from './sync.service';
import { SyncPushDto, SyncPullQueryDto } from './dto/sync.dto';

@Controller('sync')
@UseGuards(AuthGuard())
export class SyncController {
    constructor(private syncService: SyncService) { }

    @Get('pull')
    async pull(
        @GetUser() user: User,
        @Query() query: SyncPullQueryDto,
    ) {
        return this.syncService.pullChanges(user.id, query.lastSync);
    }

    @Post('push')
    async push(
        @GetUser() user: User,
        @Body() body: SyncPushDto,
    ) {
        return this.syncService.pushChanges(user.id, body);
    }
}