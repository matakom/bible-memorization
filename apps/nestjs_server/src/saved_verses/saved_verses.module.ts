/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from '../auth/auth.module';
import { SavedVerse } from './saved_verses.entity';

@Module({
    imports: [
        TypeOrmModule.forFeature([SavedVerse]),
        AuthModule,
    ],
})
export class SavedVersesModule { }