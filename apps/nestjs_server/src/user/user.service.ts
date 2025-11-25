/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable prettier/prettier */
import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { MoreThan, Repository } from 'typeorm';
import { User } from './user.entity';
import { SavedVerse } from 'src/saved_verses/saved_verses.entity';
import { Exercise } from 'src/practice/exercise.entity';
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

    async updateUserSettings(
        userId: string,
        theme?: string,
        language?: string,
    ) {
        const updateData: Partial<User> = {};

        if (theme) {
            updateData.theme = theme;
        }
        if (language) {
            updateData.language = language;
        }

        if (Object.keys(updateData).length === 0) {
            return;
        }

        const result = await this.userRepository.update(userId, updateData);

        if (result.affected === 0) {
            throw new NotFoundException(`User with ID ${userId} not found.`);
        }

        return { message: 'Settings updated successfully' };
    }

    async getUserSettings(
        userId: string,
    ) {

        const result = await this.userRepository.findOne({
            select: {
                language: true,
                theme: true
            },
            where: {
                id: userId
            }
        })

        return { language: result.language, theme: result.theme };
    }

    async getMyStats(userId: string): Promise<UserStatsDto> {
        return this._calculateStats(userId);
    }

    async getFriendStats(currentUserId: string, targetUserId: string): Promise<UserStatsDto> {
        if (currentUserId === targetUserId) {
            return this._calculateStats(currentUserId);
        }

        const isFriend = await this.friendshipRepository.findOne({
            where: [
                { userId: currentUserId, friendId: targetUserId, status: FriendshipStatus.ACCEPTED },
                { userId: targetUserId, friendId: currentUserId, status: FriendshipStatus.ACCEPTED }
            ]
        });

        if (!isFriend) {
            throw new ForbiddenException('You can only view stats of your friends.');
        }

        return this._calculateStats(targetUserId);
    }

    private async _calculateStats(userId: string): Promise<UserStatsDto> {
        const user = await this.userRepository.findOneBy({ id: userId });
        if (!user) throw new NotFoundException('User not found');

        const totalVerses = await this.verseRepository.count({ where: { userId } });

        const masteredVerses = await this.verseRepository.countBy({
            userId,
            repetitionCount: MoreThan(5),
        });

        const { count, sum } = await this.exerciseRepository
            .createQueryBuilder('exercise')
            .select('COUNT(exercise.id)', 'count')
            .addSelect('SUM(exercise.grade)', 'sum')
            .where('exercise.user_id = :userId', { userId })
            .getRawOne();

        const totalReviews = parseInt(count || '0', 10);
        const totalGradeSum = parseInt(sum || '0', 10);

        let accuracy = 0;
        if (totalReviews > 0) {
            // Max score is 5. Accuracy = (ActualScore / MaxPossibleScore) * 100
            accuracy = (totalGradeSum / (totalReviews * 5)) * 100;
        }

        return {
            userId: user.id,
            firstName: user.firstName,
            lastName: user.lastName,
            streak: user.dailyVerseStreak,
            totalVerses,
            masteredVerses,
            totalReviews,
            averageAccuracy: Math.round(accuracy),
        };
    }
}