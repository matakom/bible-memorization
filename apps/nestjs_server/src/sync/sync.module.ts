/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SyncController } from './sync.controller';
import { SyncService } from './sync.service';
import { AuthModule } from '../auth/auth.module';

// Import Entities
import { SavedVerse } from '../saved_verses/saved_verses.entity';
import { Exercise } from '../exercise/exercise.entity';
import { Friendship } from '../friendships/friendships.entity';
import { User } from '../user/user.entity';

@Module({
    imports: [
        TypeOrmModule.forFeature([SavedVerse, Exercise, Friendship, User]),
        AuthModule,
    ],
    controllers: [SyncController],
    providers: [SyncService],
})
export class SyncModule { }