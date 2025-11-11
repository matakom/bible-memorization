/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from '../auth/auth.module';
import { User } from '../user/user.entity';
import { Friendship } from './friendships.entity';
import { FriendshipsController } from './friendships.controller';
import { FriendshipsService } from './friendships.service';
import { UserModule } from '../user/user.module';

@Module({
    imports: [
        TypeOrmModule.forFeature([Friendship, User]),
        AuthModule,
        UserModule,
    ],
    controllers: [FriendshipsController],
    providers: [FriendshipsService],
})
export class FriendshipsModule { }