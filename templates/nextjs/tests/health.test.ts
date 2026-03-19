import { describe, expect, it } from "vitest";
import { checkApplicationHealth } from "@/lib/health";

describe("checkApplicationHealth", () => {
  it("returns ok when the database check succeeds", async () => {
    const snapshot = await checkApplicationHealth(async () => {
      return Promise.resolve();
    });

    expect(snapshot.status).toBe("ok");
    expect(snapshot.database).toBe("up");
    expect(snapshot.message).toBe("database reachable");
    expect(snapshot.checkedAt).toMatch(/\d{4}-\d{2}-\d{2}T/);
  });

  it("returns degraded when the database check fails", async () => {
    const snapshot = await checkApplicationHealth(async () => {
      throw new Error("boom");
    });

    expect(snapshot.status).toBe("degraded");
    expect(snapshot.database).toBe("down");
    expect(snapshot.message).toContain("boom");
  });
});
