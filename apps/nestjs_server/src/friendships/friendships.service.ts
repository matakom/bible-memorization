/* eslint-disable prettier/prettier */
import {
    BadRequestException,
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

}