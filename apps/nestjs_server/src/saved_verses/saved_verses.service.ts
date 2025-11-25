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

    async createVerse(
        dtos: CreateVerseDto[],
        user: User,
    ): Promise<SavedVerse[]> {

        const versesToSave: SavedVerse[] = [];

        await Promise.all(dtos.map(async (dto) => {
            const existing = await this.verseRepository.findOneBy({
                userId: user.id,
                book: dto.book,
                chapter: dto.chapter,
                verse: dto.verse,
                translation: dto.translation,
            });

            if (!existing) {
                const newVerse = this.verseRepository.create({
                    ...dto,
                    userId: user.id,
                    nextReviewDate: new Date(Date.now() + 24 * 60 * 60 * 1000),
                });
                versesToSave.push(newVerse);
            }
        }));

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