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

    @Column()
    book: number;

    @Column()
    chapter: number;

    @Column()
    verse: number;

    @Column({ length: 50 })
    translation: string;

    @Column({ name: 'next_review_date', type: 'date' })
    nextReviewDate: Date;

    @Column({ name: 'last_review_date', type: 'date', nullable: true })
    lastReviewDate: Date;

    @Column({ name: 'ease_factor', type: 'float', default: 2.5 })
    easeFactor: number;

    @Column({ name: 'repetition_count', type: 'int', default: 0 })
    repetitionCount: number;

    @Column({ name: 'base_complexity', type: 'float', default: 0 })
    baseComplexity: number;

    @UpdateDateColumn({ name: 'updated_at', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
    updatedAt: Date;

    @DeleteDateColumn({ name: 'deleted_at', type: 'timestamp', nullable: true })
    deletedAt: Date | null;

    @ManyToOne(() => User, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'user_id' })
    user: User;
}