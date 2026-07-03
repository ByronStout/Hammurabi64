# CLAUDE.md — Hammurabi 64

Project context for Claude Code. Read this fully at the start of every session.

## What this project is

**Hammurabi 64** — a Commodore 64 variant of the classic *Hammurabi* (*The Sumer Game*),
written in **hand-written Commodore BASIC V2**. It is a single-player, turn-based
resource-management game: you rule a river city-state, allocating grain, land, and
population each year to survive and grow.

The defining variant is a **permanent building system** across four tracks (Agricultural,
Protective, Civic, Economic), an **open-ended reign with a sustained population-target
victory**, and **scaling-pressure mechanics** that make a larger city harder to hold.

## The two source-of-truth documents

- `Hammurabi64_Specification.md` — source of truth for **mechanics, formulas, variable
  names, and UI**. When in doubt about *how something works*, cite the relevant section
  rather than inventing behavior.
- `Hammurabi64_UserStories.md` — source of truth for **what to build and in what order**,
  and for **progress tracking**. Stories are grouped into Sprints 0–9 plus Non-Functional
  and Test/Validation groups, in build order. Each story has an ID (`H64-NNN`), a T-shirt
  size (XS–XL), a MoSCoW priority (Must/Should/Could), and a `**Status:**` field.

## Tooling

- **Language:** Commodore BASIC V2 only. No assembly, no cross-compiled C.
- **Target/test:** the **VICE** emulator (warp mode for fast iteration). The developer
  loads the `.prg`/listing in VICE and tests **manually**. You cannot see the emulator —
  the developer is the test oracle, so make behavior observable on screen (see Workflow).
- **Platform:** C64, PAL and NTSC. No timing-sensitive code, so both are fine.

## How we work: one story per turn

We build **one story at a time**, in sprint order, with developer review between each.
Work the next `Not Started` story in sequence unless told otherwise. Reference stories by
**ID** (`H64-024`), never by ordinal position. For every story, follow these beats:

1. **Read and restate — do NOT write code yet.** State what the story requires, which
   line ranges of the program it touches, and exactly what you plan to change. Check it
   against the spec. Flag any ambiguity, any acceptance criterion that isn't observable on
   screen in VICE, and — if the story is **XL** — propose splitting it before coding.
2. **Flip status to `In Progress`** in `Hammurabi64_UserStories.md` once the developer
   approves the plan.
3. **Implement the minimum.** Change only the lines this story requires. Then **show the
   diff** and remind the developer to test in VICE.
4. **On developer confirmation, flip status to `Done` and commit.** Commit the source
   change **and** the updated stories doc **together in one commit**, message referencing
   the story ID (e.g. `H64-031: rat spoilage done`). Use `Blocked` instead of `Done` if
   stalled on a dependency or open question.

Respect story dependencies and sprint order: Sprint 0 (toolchain, variable declarations,
DATA tables, RNG) comes first; the core turn loop and on-screen resource display must
exist before any story that changes grain/population, or there's no way to manually verify
a formula. Within a sprint you may prioritize `Must` stories first if the developer wants
a playable core sooner.

## Progress tracking

`Hammurabi64_UserStories.md` is the single source of truth for progress. Keep each story's
`**Status:**` field current and commit the doc alongside the matching source change, so the
Git history doubles as a dated progress log keyed to story IDs.

## BASIC V2 rules — these are hard constraints

- **Variable names: only the first 2 characters are significant.** All names must be
  unique within their first two letters. Spec Section 10 already enforces this (`PO%`,
  `GR%`, `LA%`, `BL%()`, etc.) — use those exact names (see story H64-002, H64-003).
- **Type suffixes:** `XX%` = integer (countable state — people, bushels, acres, levels),
  `XX` = float (prices, multipliers, ratios), `XX$` = string. Round floats to integer
  before storing/displaying countable state (H64-100).
- **Reserved words may not appear inside the first two characters** of a variable name
  (not `TO`, `IF`, `ON`, `OR`, `FN`, etc.).

## Line numbering — per H64-001a (renumber-safe)

- **Routines start on round numbers** with gaps for inserts: e.g. resolution phases at
  1000, advisor at 5000, input at 7000.
- **Increment by 10 within a routine** so single lines can be inserted without renumbering.
- **Never renumber the whole program** to fit a few lines — a renumber turns a one-line
  change into a whole-file diff that can't be eyeballed.
- **No computed line targets** (no `GOTO 1000+X*10`). All `GOTO`/`GOSUB` destinations must
  be **literal line numbers** so CBM prg Studio's renumber command can rewrite them safely.
  Where branching on a value is needed, use `ON X GOTO` / `ON X GOSUB` with literal targets.
- A REM header at each block start documents the routine and its line range; keep a
  line-number map (which range holds which routine) in a header REM block (H64-105).

## UI constraints

- Text screen is **40 columns × 25 rows**. Layout is a fixed status panel up top plus a
  scrolling interaction/log zone below (spec Section 7). Keep within 40 columns.
- Reject impossible commands (overspending grain, planting beyond people/land/seed limits,
  negative entries) with an advisor rebuke, never a crash (H64-025, H64-102).

## Open questions that affect implementation (spec Appendix D / backlog)

Decide these before reaching the affected story; flag if a story forces the question early:
- **One build action per year vs. unlimited construction** — affects H64-024 pacing.
- **Whether save/load (H64-104) ships in the first version.**

## Guardrails — what NOT to do

- Don't rewrite or renumber more of the program than the current story requires.
- Don't change formulas or variable names away from the spec without flagging it first.
- Don't batch multiple stories into one turn unless explicitly asked.
- Don't assume a formula works — if it isn't visible on screen, add a temporary debug
  print so the developer can verify it in VICE, and note that the debug line is temporary.
- Always show the diff before committing, and always commit source + stories doc together.
