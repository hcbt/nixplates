import { TemplateHero } from "@/components/template-hero";

const stack = [
  "next@canary + react 19",
  "drizzle + postgresql",
  "biome + vitest + playwright",
  "nix flakes + devenv",
];

export default function Home() {
  return (
    <main className="mx-auto flex min-h-screen w-full max-w-5xl flex-col gap-10 px-6 py-16">
      <TemplateHero />

      <section className="rounded-xl border border-zinc-200 bg-white p-8 shadow-sm dark:border-zinc-800 dark:bg-zinc-900">
        <h2 className="text-xl font-semibold text-zinc-900 dark:text-zinc-100">
          Included stack
        </h2>
        <ul className="mt-4 grid gap-3 text-sm text-zinc-700 dark:text-zinc-300 sm:grid-cols-2">
          {stack.map((entry) => (
            <li
              key={entry}
              className="rounded-md border border-zinc-200 bg-zinc-50 px-3 py-2 dark:border-zinc-700 dark:bg-zinc-800"
            >
              {entry}
            </li>
          ))}
        </ul>
      </section>
    </main>
  );
}
