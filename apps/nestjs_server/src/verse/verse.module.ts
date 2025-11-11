/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from '../auth/auth.module';
import { Verse } from './verse.entity';
import { VerseController } from './verse.controller';
import { VerseService } from './verse.service';

@Module({
    imports: [
        TypeOrmModule.forFeature([Verse]),
        AuthModule,
    ],
    controllers: [VerseController],
    providers: [VerseService],
})
export class VerseModule { }