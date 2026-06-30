# Routing

Keyword rules: `projects/oota anything/cli/router.work`

Each `match :category do` block lists keywords, a default tool, and optional
`prefer: tool | trigger phrases`.

Scoring: count keyword hits in requirements (case-insensitive). Top four categories
become the chain. No matches → `diagrams: mermaid`.

Tool pick: if `prefer` regex matches requirements, use alternate tool; else default
from router or catalog.
