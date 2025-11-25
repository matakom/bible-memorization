/* eslint-disable prettier/prettier */
import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    ManyToOne,
    JoinColumn,
    Check,
} from 'typeorm';
import { User } from '../user/user.entity';

@Entity('verse')
@Check('book > 0')
@Check('chapter > 0')
@Check('verse > 0')
@Check('difficulty BETWEEN 1 AND 5')
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

    @Column({ name: 'next_review_date', type: 'date', nullable: true })
    nextReviewDate: Date;

    @Column({ name: 'last_review_date', type: 'date', nullable: true })
    lastReviewDate: Date;

    @Column({ type: 'smallint', default: 1 })
    difficulty: number;

    @ManyToOne(() => User, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'user_id' })
    user: User;
}