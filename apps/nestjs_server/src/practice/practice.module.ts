/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Exercise } from './exercise.entity';
import { SavedVerse } from 'src/saved_verses/saved_verses.entity';
import { AuthModule } from '../auth/auth.module';
import { UserModule } from 'src/user/user.module';

@Module({
    imports: [
        TypeOrmModule.forFeature([Exercise, SavedVerse]),
        AuthModule,
        UserModule
    ],
})
export class PracticeModule { }