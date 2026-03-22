/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable prettier/prettier */
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy, ExtractJwt } from 'passport-jwt';
import { passportJwtSecret } from 'jwks-rsa';
import { UserService } from '../user/user.service';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
    constructor(
        private readonly userService: UserService,
        private readonly configService: ConfigService,
    ) {
        const projectId = configService.get<string>('FB_PROJECT_ID');

        super({
            jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
            ignoreExpiration: false,

            secretOrKeyProvider: passportJwtSecret({
                cache: true,
                rateLimit: true,
                jwksRequestsPerMinute: 5,
                jwksUri: 'https://www.googleapis.com/robot/v1/metadata/jwk/securetoken@system.gserviceaccount.com',
            }),

            audience: projectId,
            issuer: `https://securetoken.google.com/${projectId}`,
            algorithms: ['RS256'],
        });
    }

    async validate(payload: any) {
        if (!payload.email) {
            throw new UnauthorizedException('JWT token missing email.');
        }

        return await this.userService.findOrCreateUserFromFirebase({
            email: payload.email,
            name: payload.name,
        });
    }
}