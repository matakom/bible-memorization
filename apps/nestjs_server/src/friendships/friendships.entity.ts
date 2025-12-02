/* eslint-disable prettier/prettier */
import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    CreateDateColumn,
    ManyToOne,
    JoinColumn,
    Unique,
    Check,
} from 'typeorm';
import { User } from '../user/user.entity';

export enum FriendshipStatus {
    PENDING = 'pending',
    ACCEPTED = 'accepted',
}

@Unique('unique_friendship', ['userId', 'friendId'])
@Check('no_self_friendship', '"user_id" <> "friend_id"')
@Entity('friendships')
export class Friendship {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({
        type: 'varchar',
        length: 20,
        nullable: false,
        enum: FriendshipStatus,
        default: FriendshipStatus.PENDING,
    })
    status: FriendshipStatus;

    @Column({ name: 'user_id' })
    userId: string;

    @Column({ name: 'friend_id' })
    friendId: string;

    @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
    createdAt: Date;

    // Fields for sync
    @Column({ name: 'updated_at', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
    updatedAt: Date;

    @Column({ name: 'deleted_at', type: 'timestamp', nullable: true })
    deletedAt: Date | null;

    @ManyToOne(() => User, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'user_id' })
    user: User;

    @ManyToOne(() => User, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'friend_id' })
    friend: User;
}