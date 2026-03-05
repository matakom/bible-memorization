/* eslint-disable prettier/prettier */
import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    ManyToOne,
    JoinColumn,
    Check,
    UpdateDateColumn,
    DeleteDateColumn,
} from 'typeorm';
import { User } from '../user/user.entity';

@Entity('verse')
@Check('book > 0')
@Check('chapter > 0')
@Check('verse > 0')
export class SavedVerse {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ name: 'user_id' })
    userId: string;

    // --- Verse identifier fields ---

    @Column()
    book: number;

    @Column()
    chapter: number;

    @Column()
    verse: number;

    @Column({ length: 50 })
    translation: string;

    // --- SRS fields (Pure SM-2, no HLR) ---

    @Column({ name: 'next_review_date', type: 'date' })
    nextReviewDate: Date;

    @Column({ name: 'last_review_date', type: 'date', nullable: true })
    lastReviewDate: Date;

    // "Ease Factor" (SM-2 default start is 2.5)
    @Column({ name: 'ease_factor', type: 'float', default: 2.5 })
    easeFactor: number;

    // How many times successfully recalled in a row
    @Column({ name: 'repetition_count', type: 'int', default: 0 })
    repetitionCount: number;

    // Static difficulty calculated from word count/length
    @Column({ name: 'base_complexity', type: 'float', default: 0 })
    baseComplexity: number;

    // --- Sync fields ---
    
    @UpdateDateColumn({ name: 'updated_at', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
    updatedAt: Date;

    @DeleteDateColumn({ name: 'deleted_at', type: 'timestamp', nullable: true })
    deletedAt: Date | null;

    // --- Relations ---

    @ManyToOne(() => User, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'user_id' })
    user: User;
}