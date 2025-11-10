/* eslint-disable prettier/prettier */
import { Injectable, NestMiddleware, Logger } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';

@Injectable()
export class LoggerMiddleware implements NestMiddleware {
    private logger = new Logger('HTTP');

    use(req: Request, res: Response, next: NextFunction): void {
        const { method, originalUrl } = req;
        res.on('finish', () => {
            const { statusCode } = res;
            const body = JSON.stringify(req.body);
            this.logger.log(`${method} ${originalUrl} ${statusCode} ${body}`);
            try {
                this.logger.log(`${req.headers.authorization.split(' ')[1].length}`);
            }
            catch (e) { this.logger.log(e) };
        });
        next();
    }
}
