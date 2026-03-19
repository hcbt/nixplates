import { sql } from "drizzle-orm";
import { getDb } from "@/db/client";

export type HealthStatus = "ok" | "degraded";

export interface HealthSnapshot {
  status: HealthStatus;
  database: "up" | "down";
  checkedAt: string;
  message: string;
}

export async function checkApplicationHealth(
  runDatabaseCheck: () => Promise<void> = defaultDatabaseCheck,
): Promise<HealthSnapshot> {
  try {
    await runDatabaseCheck();

    return {
      status: "ok",
      database: "up",
      checkedAt: new Date().toISOString(),
      message: "database reachable",
    };
  } catch (error) {
    return {
      status: "degraded",
      database: "down",
      checkedAt: new Date().toISOString(),
      message: getErrorMessage(error),
    };
  }
}

async function defaultDatabaseCheck() {
  const db = getDb();
  await db.execute(sql`select 1`);
}

function getErrorMessage(error: unknown) {
  if (error instanceof Error) {
    return error.message;
  }

  return "unknown database error";
}
