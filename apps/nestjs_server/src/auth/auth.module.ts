/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';
import { UserModule } from '../user/user.module';
import { JwtLoginStrategy, JwtStrategy } from './jwt.strategy';

@Module({
    imports: [
        PassportModule.register({
            defaultStrategy: 'jwt'
        }),
        UserModule,
    ],
    providers: [
        JwtStrategy,
        JwtLoginStrategy
    ],
    exports: [PassportModule],
})
export class AuthModule { }