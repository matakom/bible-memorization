/* eslint-disable prettier/prettier */
import {
    Injectable,
    NotFoundException,
    ForbiddenException,
    ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../user/user.entity';
import { Verse } from './verse.entity';
import { CreateVerseDto } from './dto/create-verse.dto';

@Injectable()
export class VerseService {
    constructor(
        @InjectRepository(Verse)
        private readonly verseRepository: Repository<Verse>,
    ) { }

    /**
     * Creates and saves a new verse for a user.
     */
    async createVerse(
        dto: CreateVerseDto,
        user: User,
    ): Promise<Verse> {
        // Check if this exact verse is already saved
        const existing = await this.verseRepository.findOneBy({
            userId: user.id,
            book: dto.book,
            chapter: dto.chapter,
            verse: dto.verse,
            translation: dto.translation,
        });

        if (existing) {
            throw new ConflictException('You have already saved this verse.');
        }

        const newVerse = this.verseRepository.create({
            ...dto,
            userId: user.id,
            // Set initial review date for tomorrow
            nextReviewDate: new Date(Date.now() + 24 * 60 * 60 * 1000),
        });

        return this.verseRepository.save(newVerse);
    }

    /**
     * Gets all saved verses for the authenticated user.
     */
    async getVersesForUser(user: User): Promise<Verse[]> {
        return this.verseRepository.find({
            where: { userId: user.id },
            order: { nextReviewDate: 'ASC', book: 'ASC' },
        });
    }

    /**
     * Deletes a specific saved verse.
     */
    async deleteVerse(verseId: string, user: User): Promise<void> {
        const verse = await this.verseRepository.findOneBy({ id: verseId });

        if (!verse) {
            throw new NotFoundException('Saved verse not found.');
        }

        // Security check: Ensure the verse belongs to the user
        if (verse.userId !== user.id) {
            throw new ForbiddenException(
                'You do not have permission to delete this verse.',
            );
        }

        await this.verseRepository.remove(verse);
    }
}