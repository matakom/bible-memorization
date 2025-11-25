/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './user.entity';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { SavedVerse } from 'src/saved_verses/saved_verses.entity';
import { Exercise } from 'src/practice/exercise.entity';
import { Friendship } from 'src/friendships/friendships.entity';

@Module({
    imports: [
        TypeOrmModule.forFeature([User, SavedVerse, Exercise, Friendship]),
    ],
    providers: [UserService],
    controllers: [UserController],
    exports: [UserService],
})
export class UserModule { }