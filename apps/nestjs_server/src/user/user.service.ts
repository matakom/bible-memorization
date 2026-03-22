/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable prettier/prettier */
import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { MoreThan, Repository } from 'typeorm';
import { User } from './user.entity';
import { SavedVerse } from 'src/saved_verses/saved_verses.entity';
import { Exercise } from 'src/exercise/exercise.entity';
import { UserStatsDto } from './dto/user-stats.dto';
import { Friendship, FriendshipStatus } from 'src/friendships/friendships.entity';

interface FirebasePayload {
    email: string;
    name?: string;
}

// A helper function for safe characters
function generateFriendCode(): string {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    let result = '';
    for (let i = 0; i < 6; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
}

@Injectable()
export class UserService {
    constructor(
        @InjectRepository(User)
        private readonly userRepository: Repository<User>,
        @InjectRepository(SavedVerse)
        private verseRepository: Repository<SavedVerse>,

        @InjectRepository(Exercise)
        private exerciseRepository: Repository<Exercise>,

        @InjectRepository(Friendship)
        private friendshipRepository: Repository<Friendship>,
    ) { }

    async updateSettings(userId: string, settings: { language?: string }): Promise<void> {
        await this.userRepository.update(userId, {
            ...(settings.language && { language: settings.language }),
        });
    }

    async findOrCreateUserFromFirebase(
        payload: FirebasePayload,
    ): Promise<User> {
        const existingUser = await this.userRepository.findOneBy({
            email: payload.email,
        });

        if (existingUser) {
            return existingUser;
        }

        const nameParts = payload.name?.split(' ') || [];
        const firstName = nameParts[0] || 'New';
        const lastName = nameParts.slice(1).join(' ') || 'User';
        let newCode = generateFriendCode();

        // Check for same code
        let existing = await this.userRepository.findOneBy({ friendCode: newCode });
        while (existing) {
            newCode = generateFriendCode();
            existing = await this.userRepository.findOneBy({ friendCode: newCode });
        }

        const newUser = this.userRepository.create({
            email: payload.email,
            firstName: firstName,
            lastName: lastName,
            friendCode: newCode
        });

        return this.userRepository.save(newUser);
    }

    async findByFriendCode(code: string): Promise<User | undefined> {
        return this.userRepository.findOne({
            where: { friendCode: code }
        });
    }

    async getUserStats(userId: string) {
        const user = await this.userRepository.findOne({ where: { id: userId } });
        if (!user) {
            throw new NotFoundException('User not found');
        }

        const aggResult = await this.exerciseRepository.query(`
            SELECT 
                COUNT(id)::int AS total_practices,
                COALESCE(SUM(duration_seconds), 0)::int AS time_spent,
                (COUNT(DISTINCT DATE(performed_at)) * 5) + 
                COALESCE(SUM(CASE WHEN grade >= 3 THEN 3 ELSE 1 END), 0)::int AS score
            FROM exercises
            WHERE user_id = $1 AND deleted_at IS NULL
        `, [userId]);

        const { total_practices, time_spent, score } = aggResult[0];

        const memorizedResult = await this.exerciseRepository.query(`
            SELECT COUNT(*)::int as memorized_count FROM (
                SELECT grade,
                       ROW_NUMBER() OVER(PARTITION BY verse_id ORDER BY performed_at DESC) as rn
                FROM exercises
                WHERE user_id = $1 AND deleted_at IS NULL
            ) t WHERE rn = 1 AND grade >= 3
        `, [userId]);

        const memorizedVerses = memorizedResult[0].memorized_count;

        const datesResult = await this.exerciseRepository.query(`
            SELECT DISTINCT DATE(performed_at) as practice_date
            FROM exercises
            WHERE user_id = $1 AND deleted_at IS NULL
            ORDER BY practice_date DESC
        `, [userId]);

        let currentStreak = 0;
        
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        
        const yesterday = new Date(today);
        yesterday.setDate(yesterday.getDate() - 1);

        const practiceDates = datesResult.map(row => {
            const d = new Date(row.practice_date);
            d.setHours(0, 0, 0, 0);
            return d.getTime();
        });

        if (practiceDates.length > 0) {
            const todayTime = today.getTime();
            const yesterdayTime = yesterday.getTime();
            
            let checkTime = -1;
            if (practiceDates.includes(todayTime)) {
                checkTime = todayTime;
            } else if (practiceDates.includes(yesterdayTime)) {
                checkTime = yesterdayTime;
            }

            if (checkTime !== -1) {
                for (const time of practiceDates) {
                    if (time === checkTime) {
                        currentStreak++;
                        checkTime -= 86400000;
                    } else if (time < checkTime) {
                        break;
                    }
                }
            }
        }

        return {
            userId: user.id,
            fullName: `${user.firstName} ${user.lastName}`,
            streak: Number(currentStreak) || 0,
            totalPractices: Number(total_practices) || 0,
            memorizedVerses: Number(memorizedVerses) || 0,
            timeSpentSeconds: Number(time_spent) || 0,
            score: Number(score) || 0,
        };
    }

    async deleteUserFully(userId: string) {
    return await this.userRepository.manager.transaction(async (transactionalEntityManager) => {
        await transactionalEntityManager.delete(Exercise, { userId });
        await transactionalEntityManager.delete(SavedVerse, { userId });
        
        await transactionalEntityManager.delete(Friendship, [
            { userId },
            { friendId: userId }
        ]);

        const deleteResult = await transactionalEntityManager.delete(User, { id: userId });

        if (deleteResult.affected === 0) {
            throw new NotFoundException('User not found');
        }

        return { success: true };
    });
}

}