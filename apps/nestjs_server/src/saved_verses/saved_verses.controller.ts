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
    UsePipes,
    ValidationPipe,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { GetUser } from '../auth/get-user.decorator';
import { User } from '../user/user.entity';
import { CreateVerseDto } from './dto/create-verse.dto';
import { SavedVersesService } from './saved_verses.service';
import { SavedVerse } from './saved_verses.entity';

@Controller('saved-verses')
@UseGuards(AuthGuard('jwt'))
export class SavedVersesController {
    constructor(private readonly versesService: SavedVersesService) { }

    @Post()
    @UseGuards(AuthGuard('jwt'))
    @UsePipes(new ValidationPipe({ whitelist: true }))
    async createVerse(
        @Body() createDto: CreateVerseDto[],
        @GetUser() user: User,
    ): Promise<SavedVerse[]> {
        return this.versesService.createVerse(createDto, user);
    }

    @Get()
    async getSavedVerses(@GetUser() user: User): Promise<SavedVerse[]> {
        return this.versesService.getVersesForUser(user);
    }

    @Delete(':id')
    @UseGuards(AuthGuard('jwt'))
    @HttpCode(204)
    async deleteSavedVerse(
        @Param('id', ParseIntPipe) id: string,
        @GetUser() user: User,
    ): Promise<void> {
        return this.versesService.deleteVerse(id, user);
    }
}