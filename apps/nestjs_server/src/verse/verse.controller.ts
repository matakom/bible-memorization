/* eslint-disable prettier/prettier */
import {
    Controller,
    Post,
    Get,
    Delete,
    Body,
    Param,
    UseGuards,
    ParseIntPipe,
    HttpCode,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { GetUser } from '../auth/get-user.decorator';
import { User } from '../user/user.entity';
import { Verse } from './verse.entity';
import { VerseService } from './verse.service';
import { CreateVerseDto } from './dto/create-verse.dto';

@Controller('verse')
@UseGuards(AuthGuard('jwt'))
export class VerseController {
    constructor(private readonly versesService: VerseService) { }

    @Post()
    async createVerse(
        @Body() createDto: CreateVerseDto,
        @GetUser() user: User,
    ): Promise<Verse> {
        return this.versesService.createVerse(createDto, user);
    }

    @Get()
    async getSavedVerses(@GetUser() user: User): Promise<Verse[]> {
        return this.versesService.getVersesForUser(user);
    }

    @Delete(':id')
    @HttpCode(204)
    async deleteSavedVerse(
        @Param('id', ParseIntPipe) id: string,
        @GetUser() user: User,
    ): Promise<void> {
        return this.versesService.deleteVerse(id, user);
    }
}