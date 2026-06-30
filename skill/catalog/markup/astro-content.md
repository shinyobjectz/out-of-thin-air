<!-- generated draft — needs validation -->
# astro-content (markup)

## Summary
Astro is a static-site framework whose **content collections** feature turns
Markdown/MDX files — authored as plain markup with Zod-validated frontmatter — into
deterministic, diffable static HTML. Content lives in
`src/content/<collection>/*.{md,mdx}`; collections are registered in
`src/content.config.ts` via the `glob()` loader with a Zod schema. Entries are
queried with `getEntry`/`getCollection` and rendered to HTML via `render()` →
`<Content />` in `.astro` pages, then `astro build` emits a static HTML site to
`./dist`. HTML is the primary artifact; PDF is **not** native (only via a downstream
headless-browser print step). MIT licensed, official first-party tooling. MDX support
requires the official `@astrojs/mdx` integration (`npx astro add mdx`).

## Skills
| Skill | Type | URL | License | Attribution |
|---|---|---|---|---|
| Content collections guide | official-docs | https://docs.astro.build/en/guides/content-collections/ | MIT | Astro |
| Content Collections API reference (`astro:content`) | official-docs | https://docs.astro.build/en/reference/modules/astro-content/ | MIT | Astro |
| Markdown in Astro | official-docs | https://docs.astro.build/en/guides/markdown-content/ | MIT | Astro |
| @astrojs/mdx integration | official-docs | https://docs.astro.build/en/guides/integrations-guide/mdx/ | MIT | Astro |

Primary skill: **Content collections guide** (official, MIT) — https://docs.astro.build/en/guides/content-collections/

## Toolchains
| lang / runtime | install | invoke |
|---|---|---|
| Node (scaffold + MDX) | `npm create astro@latest -- --template minimal --no-install --no-git -y && npm install && npx astro add mdx -y` | `npx astro build`  # emits static HTML to ./dist |
| Node (add to existing project) | `npm install astro @astrojs/mdx` | `npx astro build` |

## Artifact kind
**html** — `astro build` emits a static HTML site to `./dist`. Deterministic given a
fixed lockfile/deps. PDF is out of scope for the tool itself; pipe the built HTML
through a headless-browser print (`chromium --headless --print-to-pdf` or Playwright)
as a separate step if PDF is required.

## Validation
- **install**: `mkdir -p /tmp/astro-smoke && cd /tmp/astro-smoke && npm create astro@latest -- . --template minimal --install --no-git -y && npx astro add mdx -y`
- **smoke**: create `src/content/blog/post.md` with frontmatter `title`, register a
  `blog` collection in `src/content.config.ts` using `glob({ pattern: '**/*.{md,mdx}',
  base: './src/content/blog' })` + a Zod schema, add a
  `src/pages/blog/[id].astro` page that `getStaticPaths` over the collection and
  `render()`s each post into `<Content />`, then `npx astro build`.
- **expect**: Build succeeds and `./dist/blog/post/index.html` exists containing the
  rendered `<h1>Hi</h1>` and title. Verify:
  `test -f dist/blog/post/index.html && grep -q 'Hi' dist/blog/post/index.html`.

## Wrapper params
Key knobs to expose:
- **markup.title** — frontmatter title for the sample entry.
- **markup.collection** — collection name / directory under `src/content/`.
- **markup.format** — `md` or `mdx` (mdx needs `@astrojs/mdx` added).

Notes: authoring is pure markup (md/mdx + YAML/TOML/JSON frontmatter), no GUI editor,
fully git-diffable. `content.config.ts` replaced the older `src/content/config.ts`
location in Astro 5; the `glob()` loader is the current API (the legacy
implicit-collection API is deprecated). MDX rendering needs `@astrojs/mdx` added or
`.mdx` entries fail to render.
