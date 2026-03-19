import { NextResponse } from "next/server";
import { checkApplicationHealth } from "@/lib/health";

export async function GET() {
  const snapshot = await checkApplicationHealth();

  return NextResponse.json(snapshot, {
    status: snapshot.status === "ok" ? 200 : 503,
  });
}
