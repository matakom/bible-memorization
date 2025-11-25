/* eslint-disable prettier/prettier */
export class UserStatsDto {
    userId: string;
    firstName: string;
    lastName: string;
    streak: number;
    totalVerses: number; // Total saved
    masteredVerses: number; // Verses with high repetition count
    totalReviews: number; // Total exercises performed
    averageAccuracy: number; // Avg grade (0-5) formatted as percentage
}