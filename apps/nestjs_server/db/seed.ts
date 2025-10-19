/* eslint-disable */


import 'dotenv/config';
import { Client } from 'pg';

const client = new Client({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT) || 5432,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

async function seed() {
  await client.connect();

  const email = process.env.SEED_USER_EMAIL || 'test@example.com';
  const firstName = process.env.SEED_USER_FIRST_NAME || 'John';
  const lastName = process.env.SEED_USER_LAST_NAME || 'Doe';

  // Insert one user
  const res = await client.query(
    `
    INSERT INTO users (first_name, last_name, email)
    VALUES ($1, $2, $3)
    ON CONFLICT (email) DO NOTHING
    RETURNING id
    `,
    [firstName, lastName, email]
  );

  const userId = res.rows[0]?.id;
  console.log(`Seeded user with ID: ${userId}`);

  // Optional: Insert a saved verse
  if (userId) {
    await client.query(
      `
      INSERT INTO saved_verses (user_id, book, chapter, verse, translation, difficulty)
      VALUES ($1, 'John', 3, 16, 'NIV', 2)
      `,
      [userId]
    );

    console.log('Inserted sample saved verse.');
  }

  await client.end();
  console.log('Seeding completed.');
}

seed().catch((err) => {
  console.error(err);
  process.exit(1);
});
