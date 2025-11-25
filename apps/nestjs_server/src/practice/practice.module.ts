/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PracticeController } from './practice.controller';
import { PracticeService } from './practice.service';
import { Exercise } from './exercise.entity';
import { SavedVerse } from 'src/saved_verses/saved_verses.entity';
import { AuthModule } from '../auth/auth.module';

@Module({
    imports: [
        TypeOrmModule.forFeature([Exercise, SavedVerse]),
        AuthModule,
    ],
    controllers: [PracticeController],
    providers: [PracticeService],
})
export class PracticeModule { }