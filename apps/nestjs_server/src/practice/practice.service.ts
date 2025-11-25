/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable prefer-const */
/* eslint-disable prettier/prettier */
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Exercise } from './exercise.entity';
import { SavedVerse } from 'src/saved_verses/saved_verses.entity';
import { User } from '../user/user.entity';
import { UserService } from 'src/user/user.service';

// DTO for the input data
export interface PracticeResultDto {
    verseId: string;
    grade: number; // 0 to 5
    exerciseType: string;
    durationSeconds: number;
}

@Injectable()
export class PracticeService {
    constructor(
        @InjectRepository(Exercise)
        private exerciseRepository: Repository<Exercise>,
        @InjectRepository(SavedVerse)
        private verseRepository: Repository<SavedVerse>,
        private userService: UserService,
    ) { }

    async processSession(user: User, results: PracticeResultDto[]): Promise<void> {

        await this.handleStreakIncrement(user);

        // Process all results in parallel or sequence
        for (const result of results) {
            await this.updateVerseStats(user, result);
        }
    }

    private async updateVerseStats(user: User, result: PracticeResultDto) {
        const verse = await this.verseRepository.findOneBy({
            id: result.verseId,
            userId: user.id
        });

        if (!verse) return;

        // Log the history
        const exercise = this.exerciseRepository.create({
            userId: user.id,
            verseId: verse.id,
            grade: result.grade,
            exerciseType: result.exerciseType,
            durationSeconds: result.durationSeconds,
        });
        await this.exerciseRepository.save(exercise);

        // 2. SM-2 Algorithm Implementation
        let { easeFactor, repetitionCount, nextReviewDate } = verse;
        const grade = result.grade;

        if (grade >= 3) {
            // --- SUCCESS (Recalled) ---
            if (repetitionCount === 0) {
                // Interval = 1 day
                nextReviewDate = this.addDays(1);
            } else if (repetitionCount === 1) {
                // Interval = 6 days (SM-2 standard)
                nextReviewDate = this.addDays(6);
            } else {
                // Interval = Previous Interval * Ease Factor
                const currentInterval = this.getDaysDiff(verse.lastReviewDate || new Date(), verse.nextReviewDate);
                const newInterval = Math.ceil(currentInterval * easeFactor);
                nextReviewDate = this.addDays(newInterval);
            }
            repetitionCount++;
        } else {
            // --- FAILURE (Forgot) ---
            repetitionCount = 0;
            // Reset to 1 day
            nextReviewDate = this.addDays(0);
        }

        // 3. Update Ease Factor (The "Difficulty" Speed)
        // Formula: EF' = EF + (0.1 - (5-q) * (0.08 + (5-q)*0.02))
        const q = grade;
        let newEaseFactor = easeFactor + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02));

        // Safety floor (never go below 1.3 or it becomes impossible)
        if (newEaseFactor < 1.3) newEaseFactor = 1.3;

        verse.easeFactor = parseFloat(newEaseFactor.toFixed(2));
        verse.repetitionCount = repetitionCount;
        verse.nextReviewDate = nextReviewDate;
        verse.lastReviewDate = new Date();

        await this.verseRepository.save(verse);
    }

    private async handleStreakIncrement(user: User) {
        // Find last practice
        const lastExercise = await this.exerciseRepository.findOne({
            where: { userId: user.id },
            order: { performedAt: 'DESC' },
        });

        const now = new Date();

        // If this is the FIRST EVER practice
        if (!lastExercise) {
            user.dailyVerseStreak = 1;
            await this.userService.saveUser(user);
            return;
        }

        const lastDate = new Date(lastExercise.performedAt);
        const isSameDay = lastDate.toISOString().split('T')[0] === now.toISOString().split('T')[0];

        // If already practiced today return
        if (isSameDay) return;


        user.dailyVerseStreak += 1;

        await this.userService.saveUser(user);
    }

    private addDays(days: number): Date {
        const date = new Date();
        date.setDate(date.getDate() + days);
        return date;
    }

    private getDaysDiff(d1: Date | string, d2: Date | string): number {
        // Force conversion to Date object
        const date1 = new Date(d1);
        const date2 = new Date(d2);

        const t1 = date1.getTime();
        const t2 = date2.getTime();

        // Safety check: If date parsing failed
        if (Number.isNaN(t1) || Number.isNaN(t2)) return 1;

        // If dates are weird or negative interval, default to 1
        if (t2 <= t1) return 1;

        return Math.ceil((t2 - t1) / (1000 * 3600 * 24));
    }
}