/* eslint-disable prettier/prettier */
import {
    Injectable,
    NotFoundException,
    ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../user/user.entity';
import { SavedVerse } from './saved_verses.entity';
import { CreateVerseDto } from './dto/create-verse.dto';

@Injectable()
export class SavedVersesService {
    constructor(
        @InjectRepository(SavedVerse)
        private readonly verseRepository: Repository<SavedVerse>,
    ) { }

    // Helper to calculate complexity
    private calculateComplexity = (text: string): number => {
        if (!text) return 0;
        const words = text.split(/\s+/).length;
        const length = text.length;
        // TODO - needs to be tuned
        return parseFloat(((words * 0.1) + (length * 0.01)).toFixed(2));
    };

    async createVerse(dtos: CreateVerseDto[], user: User): Promise<SavedVerse[]> {
        const versesToSave: SavedVerse[] = [];

        for (const dto of dtos) {
            const existing = await this.verseRepository.findOneBy({
                userId: user.id,
                book: dto.book,
                chapter: dto.chapter,
                verse: dto.verse,
                translation: dto.translation,
            });

            if (!existing) {
                const complexity = this.calculateComplexity(dto.text || '');

                const newVerse = this.verseRepository.create({
                    ...dto,
                    userId: user.id,
                    baseComplexity: complexity,
                    easeFactor: Math.max(1.3, 2.5 - (complexity * 0.2)),

                    // First review is today
                    nextReviewDate: new Date(Date.now()),
                });

                versesToSave.push(newVerse);
            }
        }

        if (versesToSave.length > 0) {
            return await this.verseRepository.save(versesToSave);
        }

        return [];
    }

    /**
     * Gets all saved verses for the authenticated user.
     */
    async getVersesForUser(user: User): Promise<SavedVerse[]> {
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