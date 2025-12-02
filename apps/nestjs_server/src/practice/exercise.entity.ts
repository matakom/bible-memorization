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
    // 0-2: Failure, 3: Hard, 4: Good, 5: Perfect
    @Column({ type: 'int' })
    grade: number;

    @Column({ name: 'exercise_type', length: 50 })
    exerciseType: string;

    // How long the user spent on this specific attempt
    @Column({ name: 'duration_seconds', type: 'int' })
    durationSeconds: number;

    // Automatically set when the record is created
    @CreateDateColumn({ name: 'performed_at' })
    performedAt: Date;

    // Fields for sync
    @Column({ name: 'updated_at', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
    updatedAt: Date;

    @Column({ name: 'deleted_at', type: 'timestamp', nullable: true })
    deletedAt: Date | null;

    // --- RELATIONS ---

    @ManyToOne(() => User, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'user_id' })
    user: User;

    @ManyToOne(() => SavedVerse, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'verse_id' })
    verse: SavedVerse;
}