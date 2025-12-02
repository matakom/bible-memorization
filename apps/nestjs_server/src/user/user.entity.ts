/* eslint-disable prettier/prettier */
import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    CreateDateColumn,
} from 'typeorm';

@Entity('users')
export class User {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ name: 'first_name', length: 50 })
    firstName: string;

    @Column({ name: 'last_name', length: 50 })
    lastName: string;

    @Column({ length: 100, unique: true })
    email: string;

    @Column({ name: 'daily_verse_streak', default: 0 })
    dailyVerseStreak: number;

    @Column({ name: 'friend_code', unique: true, length: 6, nullable: false })
    friendCode: string;

    @Column({ length: 10, default: 'en' })
    language: string;

    // Fields for sync
    @CreateDateColumn({ name: 'updated_at' })
    updatedAt: Date;

    @CreateDateColumn({ name: 'deleted_at' })
    deletedAt: Date;

    @CreateDateColumn({ name: 'registered_at', type: 'timestamp' })
    registeredAt: Date;

    @Column({ name: 'last_login_at', type: 'timestamp', nullable: true })
    lastLoginAt: Date | null;
}
