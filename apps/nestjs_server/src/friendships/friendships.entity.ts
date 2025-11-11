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
    REJECTED = 'rejected',
}

@Unique('unique_friendship', ['userId', 'friendId'])
@Check('no_self_friendship', '"user_id" <> "friend_id"')
@Entity('friendships')
export class Friendship {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({
        type: 'varchar',
        length: 20,
        nullable: false,
        enum: FriendshipStatus,
        default: FriendshipStatus.PENDING,
    })
    status: FriendshipStatus;

    @Column({ name: 'user_id' })
    userId: number;

    @Column({ name: 'friend_id' })
    friendId: number;

    @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
    createdAt: Date;

    @ManyToOne(() => User, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'user_id' })
    user: User;

    @ManyToOne(() => User, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'friend_id' })
    friend: User;
}