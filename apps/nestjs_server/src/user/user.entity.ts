/* eslint-disable prettier/prettier */
import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    CreateDateColumn,
    UpdateDateColumn,
    DeleteDateColumn,
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

    @Column({ name: 'friend_code', unique: true, length: 6, nullable: false })
    friendCode: string;

    @Column({ length: 10, default: 'en' })
    language: string;

    @UpdateDateColumn({ name: 'updated_at' })
    updatedAt: Date;

    @DeleteDateColumn({ name: 'deleted_at', type: 'timestamp', nullable: true })
    deletedAt: Date | null;

    @CreateDateColumn({ name: 'registered_at', type: 'timestamp' })
    registeredAt: Date;

    @Column({ name: 'last_login_at', type: 'timestamp', nullable: true })
    lastLoginAt: Date | null;
}
