/* eslint-disable prettier/prettier */
import { LoggerMiddleware } from './middleware/logger.middleware';
import { Module, NestModule, MiddlewareConsumer } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { UserModule } from './user/user.module';
import { User } from './user/user.entity';
import { AuthModule } from './auth/auth.module';
import { FriendshipsModule } from './friendships/friendships.module';
import { Friendship } from './friendships/friendships.entity';
import { SavedVerse } from './saved_verses/saved_verses.entity';
import { SavedVersesModule } from './saved_verses/saved_verses.module';
import { ExerciseModule } from './exercise/exercise.module';
import { Exercise } from './exercise/exercise.entity';
import { SyncModule } from './sync/sync.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),

    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get<string>('DB_HOST'),
        port: configService.get<number>('DB_PORT'),
        username: configService.get<string>('DB_USERNAME'),
        password: configService.get<string>('DB_PASSWORD'),
        database: configService.get<string>('DB_DATABASE'),

        entities: [User, Friendship, SavedVerse, Exercise],

        // 'synchronize: true' is for development only.
        // It alters SQL structure on the go for faster development.
        synchronize: true,
      }),
    }),
    UserModule,
    AuthModule,
    FriendshipsModule,
    SavedVersesModule,
    ExerciseModule,
    SyncModule
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(LoggerMiddleware).forRoutes('*');
  }
}