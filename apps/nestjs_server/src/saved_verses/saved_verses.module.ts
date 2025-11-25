/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from '../auth/auth.module';
import { SavedVerse } from './saved_verses.entity';
import { SavedVersesController } from './saved_verses.controller';
import { SavedVersesService } from './saved_verses.service';

@Module({
    imports: [
        TypeOrmModule.forFeature([SavedVerse]),
        AuthModule,
    ],
    controllers: [SavedVersesController],
    providers: [SavedVersesService],
})
export class SavedVersesModule { }