/* eslint-disable prettier/prettier */
import {
    BadRequestException,
    ForbiddenException,
    Injectable,
    NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../user/user.entity';
import { Friendship, FriendshipStatus } from './friendships.entity';
import { CreateFriendshipDto } from './dto/create-friendship.dto';

@Injectable()
export class FriendshipsService {
    constructor(
        @InjectRepository(Friendship)
        private readonly friendshipRepository: Repository<Friendship>,
        @InjectRepository(User)
        private readonly userRepository: Repository<User>,
    ) { }

    async createRequest(
        createFriendshipDto: CreateFriendshipDto,
        requestingUser: User,
    ): Promise<Friendship> {
        const { friendCode } = createFriendshipDto;

        const receivingUser = await this.userRepository.findOneBy({
            friendCode: friendCode,
        });

        if (!receivingUser) {
            throw new NotFoundException('User with this friend code not found.');
        }

        if (receivingUser.id === requestingUser.id) {
            throw new BadRequestException('You cannot add yourself as a friend.');
        }

        const existingFriendship = await this.friendshipRepository.findOne({
            where: [
                { userId: requestingUser.id, friendId: receivingUser.id },
                { userId: receivingUser.id, friendId: requestingUser.id },
            ],
        });

        if (existingFriendship) {
            throw new BadRequestException(
                'A friendship or pending request already exists.',
            );
        }

        const newRequest = this.friendshipRepository.create({
            userId: requestingUser.id,
            friendId: receivingUser.id,
            status: FriendshipStatus.PENDING,
        });

        return this.friendshipRepository.save(newRequest);
    }

    async findAllForUser(user: User): Promise<Friendship[]> {
        const friendships = await this.friendshipRepository.find({
            where: [
                { userId: user.id },
                { friendId: user.id },
            ],
            relations: ['user', 'friend'],
            select: {
                id: true,
                status: true,
                userId: true,
                friendId: true,
                createdAt: true,
                user: {
                    id: true,
                    firstName: true,
                    lastName: true,
                },
                friend: {
                    id: true,
                    firstName: true,
                    lastName: true,
                },
            },
        });
        return friendships.map(friendship => {
            const requestDirection =
                friendship.userId === user.id ? 'sent' : 'received';

            return {
                ...friendship,
                requestDirection: requestDirection,
            };
        });
    }

    async acceptFriendship(
        friendshipId: number,
        user: User,
    ): Promise<Friendship> {
        const friendship = await this.friendshipRepository.findOneBy({
            id: friendshipId,
        });

        // Check if the request exists
        if (!friendship) {
            throw new NotFoundException('Friendship request not found.');
        }

        // Security Check - Only the receiver can accept
        if (friendship.friendId !== user.id) {
            throw new ForbiddenException(
                'You do not have permission to accept this request.',
            );
        }

        // Check request status
        if (friendship.status !== FriendshipStatus.PENDING) {
            throw new BadRequestException(
                'This request is already accepted or rejected.',
            );
        }

        // Update and save
        friendship.status = FriendshipStatus.ACCEPTED;
        return this.friendshipRepository.save(friendship);
    }

    async rejectFriendship(
        friendshipId: number,
        user: User,
    ): Promise<Friendship> {
        const friendship = await this.friendshipRepository.findOneBy({
            id: friendshipId,
        });

        // Check if the request exists
        if (!friendship) {
            throw new NotFoundException('Friendship request not found.');
        }

        // Security Check - Only the receiver can reject
        if (friendship.friendId !== user.id) {
            throw new ForbiddenException(
                'You do not have permission to accept this request.',
            );
        }

        // Check request status
        if (friendship.status !== FriendshipStatus.PENDING) {
            throw new BadRequestException(
                'This request is already accepted or rejected.',
            );
        }

        // Update and save
        friendship.status = FriendshipStatus.REJECTED;
        return this.friendshipRepository.save(friendship);
    }

}