/* eslint-disable prettier/prettier */
import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    ManyToOne,
    JoinColumn,
    UpdateDateColumn,
    DeleteDateColumn,
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

    @Column({ name: 'performed_at' })
    performedAt: Date;

    @UpdateDateColumn({ name: 'updated_at', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
    updatedAt: Date;

    @DeleteDateColumn({ name: 'deleted_at', type: 'timestamp', nullable: true })
    deletedAt: Date | null;

    @ManyToOne(() => User, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'user_id' })
    user: User;

    @ManyToOne(() => SavedVerse, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'verse_id' })
    verse: SavedVerse;
}