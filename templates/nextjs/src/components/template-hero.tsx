import Link from "next/link";
import { Button } from "@/components/ui/button";

export function TemplateHero() {
  return (
    <section className="flex flex-col gap-6 rounded-xl border border-zinc-200 bg-white p-8 shadow-sm dark:border-zinc-800 dark:bg-zinc-900">
      <p className="text-xs font-semibold uppercase tracking-[0.18em] text-zinc-500">
        nixplates nextjs template
      </p>
      <h1 className="text-3xl font-semibold tracking-tight text-zinc-900 dark:text-zinc-100 sm:text-4xl">
        Full-stack Next.js canary starter with Drizzle and PostgreSQL.
      </h1>
      <p className="max-w-2xl text-base text-zinc-600 dark:text-zinc-300">
        Built for Nix flakes + devenv, with Biome checks, Vitest unit tests, and
        Playwright UI coverage from day one.
      </p>
      <div className="flex flex-col gap-3 sm:flex-row">
        <Button asChild>
          <Link href="/api/health">Open health endpoint</Link>
        </Button>
        <Button asChild variant="outline">
          <a
            href="https://nextjs.org/docs"
            target="_blank"
            rel="noopener noreferrer"
          >
            Next.js docs
          </a>
        </Button>
      </div>
    </section>
  );
}
