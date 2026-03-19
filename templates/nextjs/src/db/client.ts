import { drizzle } from "drizzle-orm/node-postgres";
import { Pool } from "pg";
import * as schema from "@/db/schema";

const globalForDatabase = globalThis as unknown as {
  pool?: Pool;
};

function createPool() {
  const connectionString = process.env.DATABASE_URL;

  if (!connectionString) {
    throw new Error("DATABASE_URL is not set.");
  }

  return new Pool({ connectionString });
}

function getPool() {
  if (!globalForDatabase.pool) {
    globalForDatabase.pool = createPool();
  }

  return globalForDatabase.pool;
}

export function getDb() {
  return drizzle(getPool(), { schema });
}
