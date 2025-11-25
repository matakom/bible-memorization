/* eslint-disable prettier/prettier */
import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    ManyToOne,
    JoinColumn,
    CreateDateColumn,
} from 'typeorm';
import { User } from '../user/user.entity';
import { SavedVerse } from 'src/saved_verses/saved_verses.entity';

@Entity('exercises')
export class Exercise {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ name: 'user_id' })
    userId: string;

    @Column({ name: 'verse_id' })
    verseId: string;

    // 0-5 grade (SM-2 standard)
    @Column({ type: 'int' })
    grade: number;

    @Column({ name: 'exercise_type', length: 50 })
    exerciseType: string;

    @Column({ name: 'duration_seconds', type: 'int' })
    durationSeconds: number;

    @CreateDateColumn({ name: 'performed_at' })
    performedAt: Date;

    @ManyToOne(() => User, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'user_id' })
    user: User;

    @ManyToOne(() => SavedVerse, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'verse_id' })
    verse: SavedVerse;
}