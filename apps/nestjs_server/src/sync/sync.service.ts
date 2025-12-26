/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable prettier/prettier */
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThan, } from 'typeorm';
import { SavedVerse } from '../saved_verses/saved_verses.entity';
import { Exercise } from '../practice/exercise.entity';
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
    // 1. PULL: Get changes since timestamp
    // ==========================================================
    async pullChanges(userId: string, lastSyncStr?: string) {
        // If no timestamp provided, sync everything (epoch 0)
        const lastSync = lastSyncStr ? new Date(lastSyncStr) : new Date(0);

        const verses = await this.verseRepo.find({
            where: { userId, updatedAt: MoreThan(lastSync) },
            withDeleted: true, // IMPORTANT: Include soft-deleted rows so client knows to delete them
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
            // IMPORTANT: We must join the tables to get the names
            relations: ['user', 'friend'],
        });

        // 2. Flatten the data for the client
        // The client expects 'friendFirstName' and 'friendLastName', but the DB
        // has them nested inside the 'user' or 'friend' object.
        const friendships = rawFriendships.map(f => {
            // Determine who the "Other Person" is.
            // If I am the sender (userId), the other is 'friend'.
            // If I am the receiver (friendId), the other is 'user'.
            const otherPerson = f.userId === userId ? f.friend : f.user;

            return {
                ...f, // Keep original fields (id, status, dates)

                // Add the flattened fields expected by Flutter
                friendFirstName: otherPerson ? otherPerson.firstName : 'Unknown',
                friendLastName: otherPerson ? otherPerson.lastName : '',

                // Optional: Remove the heavy nested objects to save bandwidth
                user: undefined,
                friend: undefined,
            };
        });

        // Also sync User profile changes
        const user = await this.userRepo.findOne({
            where: { id: userId, updatedAt: MoreThan(lastSync) },
        });

        return {
            timestamp: new Date(), // Current server time
            changes: {
                verses,
                exercises,
                friendships,
                user: user ? [user] : [],
            }
        };
    }

    // ==========================================================
    // 2. PUSH: Save changes from client
    // ==========================================================
    async pushChanges(userId: string, payload: SyncPushDto) {
        // 1. Save Verses
        if (payload.verses && payload.verses.length > 0) {
            // Force userId to match the authenticated user (Security)
            const versesToSave = payload.verses.map(v => ({ ...v, userId }));
            await this.verseRepo.save(versesToSave);
        }

        // 2. Save Exercises
        if (payload.exercises && payload.exercises.length > 0) {
            const exercisesToSave = payload.exercises.map(e => ({ ...e, userId }));
            await this.exerciseRepo.save(exercisesToSave);
        }

        // 3. Save Friendships
        // Note: Logic is complex here (validating IDs), usually clients don't 
        // "create" friendships offline via sync, they use specific endpoints. 
        // But for status updates (e.g. blocking/deleting), it works.
        if (payload.friendships && payload.friendships.length > 0) {
            // Basic implementation:
            // Ensure the user is actually part of this friendship
            const validFriendships = payload.friendships.filter(f =>
                f.userId === userId || f.friendId === userId
            );
            await this.friendshipRepo.save(validFriendships);
        }

        if (payload.user) {
            // We only update specific settings, never the ID or Email
            await this.userRepo.update(userId, {
                language: payload.user.language,
                // Ensure 'language' exists in your User Entity
            });
        }

        return { success: true };
    }
}