/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable prettier/prettier */
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThan } from 'typeorm';
import { SavedVerse } from '../saved_verses/saved_verses.entity';
import { Exercise } from '../exercise/exercise.entity';
import { Friendship } from '../friendships/friendships.entity';
import { User } from '../user/user.entity';
import { SyncPushDto } from './dto/sync.dto';

@Injectable()
export class SyncService {
    constructor(
        @InjectRepository(SavedVerse)
        private verseRepo: Repository<SavedVerse>,
        @InjectRepository(Exercise)
        private exerciseRepo: Repository<Exercise>,
        @InjectRepository(Friendship)
        private friendshipRepo: Repository<Friendship>,
        @InjectRepository(User)
        private userRepo: Repository<User>,
    ) { }

    // ==========================================================
    // 1. PULL: Server -> Client
    // ==========================================================
    async pullChanges(userId: string, lastSyncStr?: string) {
        // If no timestamp provided, sync everything (epoch 0)
        const lastSync = lastSyncStr ? new Date(lastSyncStr) : new Date(0);

        const verses = await this.verseRepo.find({
            where: { userId, updatedAt: MoreThan(lastSync) },
            withDeleted: true, // Includes soft-deleted rows
        });

        const exercises = await this.exerciseRepo.find({
            where: { userId, updatedAt: MoreThan(lastSync) },
            withDeleted: true,
        });

        const rawFriendships = await this.friendshipRepo.find({
            where: [
                { userId, updatedAt: MoreThan(lastSync) },
                { friendId: userId, updatedAt: MoreThan(lastSync) }
            ],
            withDeleted: true,
            relations: ['user', 'friend'],
        });

        // Flatten the data for the Flutter client
        const friendships = rawFriendships.map(f => {
            const otherPerson = f.userId === userId ? f.friend : f.user;

            return {
                id: f.id,
                status: f.status,
                // Explicitly grab the IDs, falling back to the relation object if TypeORM hid them
                userId: f.userId || (f.user ? f.user.id : ''),
                friendId: f.friendId || (f.friend ? f.friend.id : ''),
                updatedAt: f.updatedAt,
                deletedAt: f.deletedAt,
                
                friendFirstName: otherPerson ? otherPerson.firstName : 'Unknown',
                friendLastName: otherPerson ? otherPerson.lastName : '',
            };
        });

        // Sync User profile changes
        const user = await this.userRepo.findOne({
            where: { id: userId, updatedAt: MoreThan(lastSync) },
        });

        return {
            timestamp: new Date(), // Current server time to save on client
            changes: {
                verses,
                exercises,
                friendships,
                user: user ? [user] : [],
            }
        };
    }

    // ==========================================================
    // 2. PUSH: Client -> Server
    // ==========================================================
    async pushChanges(userId: string, payload: SyncPushDto) {
        // 1. Save Verses
        if (payload.verses && payload.verses.length > 0) {
            // Force userId to match the authenticated user to prevent data hijacking
            const versesToSave = payload.verses.map(v => ({ ...v, userId }));
            await this.verseRepo.save(versesToSave);
        }

        // 2. Save Exercises (Flutter sends exerciseType as a string automatically)
        if (payload.exercises && payload.exercises.length > 0) {
            const exercisesToSave = payload.exercises.map(e => ({ ...e, userId }));
            await this.exerciseRepo.save(exercisesToSave);
        }

        // 3. Save Friendships
        if (payload.friendships && payload.friendships.length > 0) {
            // Ensure the user is actually part of this friendship record
            const validFriendships = payload.friendships.filter(f =>
                f.userId === userId || f.friendId === userId
            );
            await this.friendshipRepo.save(validFriendships);
        }

        // 4. Save User Settings
        if (payload.user) {
            await this.userRepo.update(userId, {
                language: payload.user.language,
            });
        }

        return { success: true };
    }
}