/* eslint-disable prettier/prettier */
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';

interface FirebasePayload {
    email: string;
    name?: string;
}

@Injectable()
export class UserService {
    constructor(
        @InjectRepository(User)
        private readonly userRepository: Repository<User>,
    ) { }

    async findOrCreateUserFromFirebase(
        payload: FirebasePayload,
    ): Promise<User> {
        const existingUser = await this.userRepository.findOneBy({
            email: payload.email,
        });

        if (existingUser) {
            return existingUser;
        }

        const nameParts = payload.name?.split(' ') || [];
        const firstName = nameParts[0] || 'New';
        const lastName = nameParts.slice(1).join(' ') || 'User';

        const newUser = this.userRepository.create({
            email: payload.email,
            firstName: firstName,
            lastName: lastName,
        });

        return this.userRepository.save(newUser);
    }

    async updateUserSettings(
        userId: number,
        theme?: string,
        language?: string,
    ) {
        const updateData: Partial<User> = {};

        if (theme) {
            updateData.theme = theme;
        }
        if (language) {
            updateData.language = language;
        }

        if (Object.keys(updateData).length === 0) {
            return;
        }

        const result = await this.userRepository.update(userId, updateData);

        if (result.affected === 0) {
            throw new NotFoundException(`User with ID ${userId} not found.`);
        }

        return { message: 'Settings updated successfully' };
    }

    async getUserSettings(
        userId: number,
    ) {

        const result = await this.userRepository.findOne({
            select: {
                language: true,
                theme: true
            },
            where: {
                id: userId
            }
        })

        return { language: result.language, theme: result.theme };
    }
}