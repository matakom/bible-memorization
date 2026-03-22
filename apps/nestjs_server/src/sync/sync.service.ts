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

    async pullChanges(userId: string, lastSyncStr?: string) {
        // If no timestamp provided, sync everything (epoch 0)
        const lastSync = lastSyncStr ? new Date(lastSyncStr) : new Date(0);

        const verses = await this.verseRepo.find({
            where: { userId, updatedAt: MoreThan(lastSync) },
            withDeleted: true,
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

        const friendships = rawFriendships.map(f => {
            const otherPerson = f.userId === userId ? f.friend : f.user;
            return {
                id: f.id,
                status: f.status,
                userId: f.userId || (f.user ? f.user.id : ''),
                friendId: f.friendId || (f.friend ? f.friend.id : ''),
                updatedAt: f.updatedAt,
                deletedAt: f.deletedAt,

                friendFirstName: otherPerson ? otherPerson.firstName : 'Unknown',
                friendLastName: otherPerson ? otherPerson.lastName : '',
            };
        });

        const user = await this.userRepo.findOne({
            where: { id: userId, updatedAt: MoreThan(lastSync) },
        });

        return {
            timestamp: new Date(),
            changes: {
                verses,
                exercises,
                friendships,
                user: user ? [user] : [],
            }
        };
    }

    async pushChanges(userId: string, payload: SyncPushDto) {
        if (payload.verses && payload.verses.length > 0) {
            const versesToSave = payload.verses.map(v => ({ ...v, userId }));
            await this.verseRepo.save(versesToSave);
        }

        if (payload.exercises && payload.exercises.length > 0) {
            const exercisesToSave = payload.exercises.map(e => ({ ...e, userId }));
            await this.exerciseRepo.save(exercisesToSave);
        }

        if (payload.friendships && payload.friendships.length > 0) {
            const validFriendships = payload.friendships.filter(f =>
                f.userId === userId || f.friendId === userId
            );
            await this.friendshipRepo.save(validFriendships);
        }

        if (payload.user) {
            await this.userRepo.update(userId, {
                language: payload.user.language,
            });
        }

        return { success: true };
    }
}