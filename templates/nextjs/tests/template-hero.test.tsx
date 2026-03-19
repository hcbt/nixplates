import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import { TemplateHero } from "@/components/template-hero";

describe("TemplateHero", () => {
  it("renders the template heading", () => {
    render(<TemplateHero />);

    expect(
      screen.getByRole("heading", {
        name: /full-stack next\.js canary starter/i,
      }),
    ).toBeInTheDocument();
  });
});
