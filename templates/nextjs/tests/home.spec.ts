import { expect, test } from "@playwright/test";

test("home page renders template hero", async ({ page }) => {
  await page.goto("/");

  await expect(
    page.getByRole("heading", {
      name: /full-stack next\.js canary starter/i,
    }),
  ).toBeVisible();
});

test("health endpoint returns structured status", async ({ request }) => {
  const response = await request.get("/api/health");
  expect([200, 503]).toContain(response.status());

  const payload = await response.json();
  expect(payload).toMatchObject({
    status: expect.stringMatching(/^(ok|degraded)$/),
    database: expect.stringMatching(/^(up|down)$/),
    message: expect.any(String),
  });
});
