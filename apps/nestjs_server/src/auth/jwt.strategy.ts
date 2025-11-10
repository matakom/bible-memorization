/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable prettier/prettier */
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy, ExtractJwt } from 'passport-jwt';
import { JwksClient, RsaSigningKey } from 'jwks-rsa';
import { UserService } from '../user/user.service';
import { ConfigService } from '@nestjs/config';
import { Request } from 'express';

interface JwtHeader {
    kid: string;
}

interface FirebasePayload {
    email: string;
    name?: string;
    iss: string;
    aud: string;
    sub: string;
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
    private jwksClient: JwksClient;

    constructor(
        private readonly userService: UserService,
        private readonly configService: ConfigService,
    ) {
        const firebaseProjectId = configService.get<string>('FB_PROJECT_ID');
        if (!firebaseProjectId) {
            throw new Error('FB_PROJECT_ID is not set in .env file');
        }

        super({
            jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
            ignoreExpiration: false,
            algorithms: ['RS256'],
            issuer: `https://securetoken.google.com/${firebaseProjectId}`,
            audience: firebaseProjectId,

            secretOrKeyProvider: (
                request: Request,
                rawJwtToken: string,
                done: (err: Error | null, key?: string | Buffer) => void,
            ) => {
                const header = JSON.parse(
                    Buffer.from(rawJwtToken.split('.')[0], 'base64').toString(),
                ) as JwtHeader;

                if (!header.kid) {
                    return done(new UnauthorizedException('JWT missing kid in header'));
                }

                this.jwksClient.getSigningKey(
                    header.kid,
                    (err: Error | null, key: RsaSigningKey) => {
                        if (err) {
                            return done(new UnauthorizedException('Failed to get signing key'));
                        }
                        const signingKey = key.getPublicKey();
                        done(null, signingKey);
                    },
                );
            },
        });

        this.jwksClient = new JwksClient({
            jwksUri: 'https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com',
        });
    }

    async validate(payload: FirebasePayload) {
        if (!payload.email) {
            throw new UnauthorizedException('JWT token missing email.');
        }

        try {
            const user = await this.userService.findOrCreateUserFromFirebase({
                email: payload.email,
                name: payload.name,
            });

            return user;
        } catch (error) {
            if (error instanceof Error) {
                throw new UnauthorizedException(
                    `Could not find or create user: ${error.message}`,
                );
            }
            throw new UnauthorizedException('Could not find or create user.');
        }
    }
}