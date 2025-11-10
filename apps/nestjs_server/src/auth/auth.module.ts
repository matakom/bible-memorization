/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';
import { UserModule } from '../user/user.module';
import { JwtStrategy } from './jwt.strategy';

@Module({
    imports: [
        PassportModule.register({
            defaultStrategy: 'jwt'
        }),
        UserModule,
    ],
    providers: [
        JwtStrategy,
    ],
    exports: [PassportModule],
})
export class AuthModule { }