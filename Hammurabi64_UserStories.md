# Hammurabi 64 — User Stories (Development Backlog)

> **Source:** Hammurabi C64 Variant — Game Specification (Draft v1.8)
> **Format:** Story statement + acceptance-criteria bullets
> **Granularity:** Small, dev-ready tasks
> **Metadata:** T-shirt size (XS/S/M/L/XL) + MoSCoW priority (Must / Should / Could / Won't) + Status
> **Organization:** Grouped by build order / sprint sequence (single flat backlog; stretch goals and optional features excluded per scoping)

**Legend**
- **Size:** XS (trivial), S (small), M (medium), L (large), XL (very large — consider splitting further during sprint planning)
- **Priority:** Must / Should / Could (MoSCoW; "Won't" items are simply excluded here)
- **Status:** `Not Started` → `In Progress` → `Done` (use `Blocked` if stalled on a dependency or open question). Update a story's status field as work moves; the field lives on the same line as Size and Priority.
- Story IDs are prefixed `H64-` and numbered within sprint groups.

**Tracking workflow (Git)**
- This document is the single source of truth for progress — keep it in the project's Git repo alongside the BASIC source.
- When a story's status changes, edit its `**Status:**` field and commit, referencing the story ID in the message (e.g. `H64-031: rat spoilage done`).
- Committing the doc with each status change gives a dated progress history for free, and pairs naturally with committing the corresponding `.prg`/source change in the same commit.

---

## Sprint 0 — Project Setup & Foundations

### H64-001 — Toolchain & emulator build-run loop
**Size:** XS · **Priority:** Must · **Status:** Done

As a developer, I want a one-key build-and-run loop from CBM prg Studio into VICE so that I can iterate quickly.
- CBM prg Studio project created and configured to assemble/tokenize the BASIC source to a `.prg`.
- VICE set as the emulator in CBM prg Studio so build-and-run launches the `.prg` directly.
- Warp mode confirmed working in VICE for fast iteration.
- *(Both tools already installed — this story is configuration only.)*

### H64-001a — BASIC source organization with line numbers
**Size:** XS · **Priority:** Should · **Status:** Done

As a developer, I want a deliberate line-numbering scheme so that the source stays navigable and editable as it grows.
- Routines start on round numbers (e.g. resolution phases at 1000, advisor at 5000, input at 7000) with gaps left for inserts.
- Lines incremented by 10 within a routine so single lines can be inserted without renumbering.
- A comment header (REM) at each block start documents the routine and its line range.
- GOTO/GOSUB targets reference these block starts, not arbitrary mid-routine lines.
- No computed line targets (e.g. `GOTO 1000+X*10`) — all GOTO/GOSUB destinations are literal line numbers so CBM prg Studio's renumber command can safely rewrite them. Use `ON X GOTO`/`ON X GOSUB` with literal targets where branching on a value is needed.

### H64-001b — Tokenizer / line-length sanity check
**Size:** XS · **Priority:** Should · **Status:** Done

As a developer, I want to confirm tokenized output stays within BASIC V2 limits so that long lines don't silently truncate.
- No logical line exceeds the 80-character (2 screen rows) BASIC V2 input limit after tokenizing.
- Build produces a loadable `.prg` with no tokenizer warnings.

### H64-002 — Variable-naming convention guard
**Size:** XS · **Priority:** Must · **Status:** Done

As a developer, I want documented naming conventions so that two-character BASIC V2 name collisions are avoided.
- Convention recorded: `XX%` integer, `XX` float, `XX$` string.
- Reserved-word avoidance list noted (`TO`, `IF`, `ON`, `OR`, `FN`).
- All names unique within first two characters.

### H64-003 — Core scalar state variables declared
**Size:** S · **Priority:** Must · **Status:** Done

As a developer, I want all core scalar state variables initialized so that the game has a single source of truth for state.
- Declares/initializes `YR% PO% GR% LA% PR% PL% FE% ST% BI% IM% DE% HV% HD%`.
- Each set to a defined starting value at game start.
- Integer type (`%`) used for all countable state.

### H64-004 — Building-level array declared
**Size:** XS · **Priority:** Must · **Status:** Done

As a developer, I want the building-level array set up so that building state persists across years.
- `DIM BL%(7)` with index map 0=Irrigation … 7=Tax Office.
- All levels initialized to 0 at game start.

### H64-005 — Building economics tables loaded from DATA
**Size:** S · **Priority:** Must · **Status:** Done

As a developer, I want building cost/upkeep/name tables read from DATA so that economics are data-driven.
- `DIM BC%(7) BU%(7) BN$(7)`.
- DATA lines populate cost, upkeep, and name per the spec table.
- Values match spec (e.g. Irrigation 800/40, Granary 600/20, …).

### H64-006 — Tunable constants centralized
**Size:** XS · **Priority:** Must · **Status:** Done

As a developer, I want all tunable rates defined as named constants so that balancing is a single-location edit.
- Defines `TG% HY% SE EA% WK% BR DR TX SR` with suggested values.
- Formula code references constants, not literals.

### H64-007 — Seeded RNG from hardware source
**Size:** S · **Priority:** Must · **Status:** Done

As a developer, I want `RND()` seeded from a changing hardware source so that games differ run-to-run.
- Seed captured from CIA timer or raster value at first keypress.
- Two fresh runs produce different event sequences.

---

## Sprint 1 — Turn Skeleton & Status Display

### H64-010 — Turn loop scaffold
**Size:** M · **Priority:** Must · **Status:** Done

As a developer, I want the year/turn loop structure in place so that resolution steps can be slotted in.
- Loop advances `YR%` each cycle.
- Phases ordered: display → advisor → decisions → end-year resolution.
- Loop exits on victory or loss flag.

### H64-011 — 40×25 status panel layout
**Size:** M · **Priority:** Must · **Status:** In Progress

As a player, I want a fixed status panel so that I can see vital numbers at a glance.
- Renders status bar (title, `YR%`, `PO%`) on rows 1–2.
- Resources block (grain, land, price, fed/total, planted, seed) rows 3–5.
- Buildings block (levels, upkeep, admin, threat) rows 6–8.
- Fits within 40 columns × 25 rows without wrap artifacts.

### H64-012 — Scrolling event/report log zone
**Size:** S · **Priority:** Must · **Status:** Not Started

As a player, I want a scrolling log area so that yearly events and prompts appear without disturbing the status panel.
- Log occupies rows 9–20 and scrolls.
- Status panel remains fixed while log scrolls.

### H64-013 — Command line / verb menu
**Size:** S · **Priority:** Must · **Status:** Not Started

As a player, I want a command prompt so that I can choose actions each turn.
- Verb menu shows Buy/Sell, Build, Plant, End Year (rows 22–24).
- Input prompt accepts a verb selection.

### H64-014 — Game-start greeting
**Size:** XS · **Priority:** Should · **Status:** Not Started

As a player, I want a greeting on the first turn so that the reign opens in the advisor's voice.
- First turn shows a greeting line instead of a yearly report.
- Line drawn at random from the greeting set.

---

## Sprint 2 — Player Decisions (Input & Validation)

### H64-020 — Buy land
**Size:** S · **Priority:** Must · **Status:** Not Started

As a player, I want to buy land at the year's price so that I can expand planting capacity.
- Prompts for acres; deducts `acres × buy_price` from `GR%`.
- Increases `LA%` by acres bought.
- Rejects purchase exceeding available grain.

### H64-021 — Sell land
**Size:** S · **Priority:** Must · **Status:** Not Started

As a player, I want to sell land so that I can raise grain in a pinch.
- Prompts for acres; adds proceeds to `GR%`, reduces `LA%`.
- Rejects selling more land than owned.

### H64-022 — Allocate grain to feed population
**Size:** S · **Priority:** Must · **Status:** Not Started

As a player, I want to allocate grain to feed people so that I control starvation risk.
- Prompts for grain to feed; cannot exceed `GR%`.
- Allocation stored for end-year starvation resolution.

### H64-023 — Choose acreage to plant
**Size:** M · **Priority:** Must · **Status:** Not Started

As a player, I want to choose acres to plant so that I set up the harvest.
- Enforces `A_max = MIN(P×WK, G/SE, L)`.
- Deducts seed grain (`SE` per acre) from `GR%`.
- Rejects planting beyond people/land/seed limits.

### H64-024 — Build / upgrade a building
**Size:** M · **Priority:** Must · **Status:** Not Started

As a player, I want to construct or upgrade buildings so that I can permanently improve the city.
- Lists each building: name, current level, next-level cost, effect.
- Next-level cost = `base_cost × 1.5^(level-1)`.
- Deducts cost, increments `BL%(i)`, rejects if grain insufficient.

### H64-025 — Input validation & advisor rebukes
**Size:** S · **Priority:** Must · **Status:** Not Started

As a player, I want invalid commands rejected gracefully so that the game never crashes on bad input.
- Overspending, over-planting, and negative entries are rejected.
- Each rejection prints a random advisor rebuke line, not an error.
- Control returns to the command prompt.

### H64-026 — Confirm End Year
**Size:** XS · **Priority:** Must · **Status:** Not Started

As a player, I want to confirm before ending the year so that I don't resolve the turn accidentally.
- "End Year" asks for confirmation before resolution.
- Cancelling returns to the decision phase.

---

## Sprint 3 — Harvest, Spoilage & Economy Resolution

### H64-030 — Harvest yield calculation
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want harvest computed from planted acres and yield so that grain stores grow.
- `base_yield = RND(1..6)`; `yield/acre = base_yield + 0.5×irr`.
- `harvest = A × yield/acre`; stored to `HV%` and added to `GR%`.

### H64-031 — Rat spoilage with Granary mitigation
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want rat spoilage applied to stored grain so that hoarding has a cost.
- `spoil_rate = chance × 0.5^gran`, effective cap ~90% reduction.
- `grain_lost = G × spoil_rate` deducted from `GR%`.

### H64-032 — Land price with scarcity & marketplace
**Size:** M · **Priority:** Must · **Status:** Not Started

As a developer, I want the buy price computed with scarcity and marketplace factors so that expansion scales in cost.
- `scarcity = 1 + L/2000`.
- `buy_price = (17 + RND(0..9)) × scarcity × MAX(0.5, 1 - 0.10×mkt)`.
- Price stored in `PR%` for display.

### H64-033 — Tax Office income
**Size:** S · **Priority:** Should · **Status:** Not Started

As a developer, I want Tax Office income collected at year-end so that population growth yields passive grain.
- If `tx >= 1`: `tax_income = INT(P × 0.5 × tx)` added to `GR%`.
- No income when building has degraded to level 0.
- Collected first in resolution order (before harvest).

---

## Sprint 4 — Random Events & Disaster Mitigation

### H64-040 — Event roll framework
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want a single step that rolls which events fire so that event timing is centralized and ordered.
- Determines flood, raid, and plague firing in resolution step 4.
- Plague firing is rolled here but its deaths are applied in population update (step 7).

### H64-041 — Flood event with Levee mitigation
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want floods to cause losses reduced by levees so that protective building matters.
- `flood_loss = base_flood × MAX(0, 1 - 0.30×lev)`.
- Applies grain/land loss; floored at 0 (no negative loss).

### H64-042 — Raid event with escalation & wall mitigation
**Size:** M · **Priority:** Must · **Status:** Not Started

As a developer, I want raids that scale with wealth and are reduced by walls so that growth attracts danger.
- `prosperity = G + L×20 + P×5`.
- `raid_chance = base_raid_chance + prosperity/50000`.
- `raid_loss = base_raid × (1 + prosperity/40000) × MAX(0, 1 - 0.20×wall)`.

### H64-043 — Plague chance (density-driven) with Aqueduct mitigation
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want plague chance driven by density and reduced by aqueduct so that crowding drives disease.
- `density = P / MAX(L,1)`.
- `plague_chance = base_plague × (1 + density/8) × MAX(0, 1 - 0.15×aqu)`.

### H64-044 — Mitigation floor guard (cap at 100%)
**Size:** XS · **Priority:** Must · **Status:** Not Started

As a developer, I want all `(1 - k×level)` terms floored at 0 so that high building levels never invert a loss into a gain.
- Levee, wall, and aqueduct mitigation terms wrapped in `MAX(0, …)`.
- Verified: `lev>=4`, `wall>=5`, `aqu>=7` produce zero loss, not negative.

---

## Sprint 5 — Upkeep & Population Dynamics

### H64-050 — Building upkeep + admin overhead
**Size:** M · **Priority:** Must · **Status:** Not Started

As a developer, I want total upkeep deducted at year-end so that an over-built city is penalized.
- `building_upkeep = SUM(level × upkeep_per_level)`.
- `admin_cost = INT(P/100) × 10`; `total_upkeep = building_upkeep + admin_cost`.
- Stored to `UP%`/`AD%` for display.

### H64-051 — Building degradation on unpaid upkeep
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want a building to degrade when upkeep is unmet so that maintenance has stakes.
- If `G < total_upkeep`, degrade one building by one level.
- Degradation reflected in `BL%()` and next-year effects.

### H64-052 — Births calculation
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want births computed from feeding so that a fed city grows internally.
- `fed_ratio = fed / P`.
- `births = INT(P × 0.03 × fed_ratio)`; zero if no one fed.

### H64-053 — Immigration calculation
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want immigration computed from prosperity and crowding so that arrivals reward expansion.
- `prosperity = G + L×20 + P×5`.
- `room = MAX(0, 1 - density/10)`; `immigration = INT((prosperity/4000) × room)`.
- Falls to zero at ~10 people/acre.

### H64-054 — Civic growth bonuses (Aqueduct + Temple)
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want civic buildings to boost births so that civic investment pays off.
- `growth_base = INT(births × (1 + 0.25×aqu) × (1 + 0.05×tmp))`.
- Bonuses apply to births only, not immigrants.

### H64-055 — Deaths (baseline + plague)
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want deaths computed as baseline plus plague so that mortality is realistic.
- `base_deaths = INT(P × 0.02)`.
- If plague fired: `plague_deaths = INT(P × (0.10 + RND×0.15) × MAX(0, 1 - 0.15×aqu))`.
- `deaths = base_deaths + plague_deaths`; stored to `DE%`.

### H64-056 — Starvation resolution
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want starvation computed from feeding so that underfeeding kills.
- `fed = INT(G_allocated / EA)`; `starved = MAX(0, P - fed)`.
- `FE%`/`ST%` updated for display.

### H64-057 — Population update (single source of truth)
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want one population-update step so that births/immigration/deaths/starved are never double-counted.
- `new_pop = P + growth_base + immigration - deaths - starved`.
- All four terms kept as separate subtractions/additions.
- `PO%` updated once per turn.

---

## Sprint 6 — Win/Loss Conditions & Scoring

### H64-060 — Starvation revolt loss
**Size:** XS · **Priority:** Must · **Status:** Not Started

As a player, I want the game to end if too many starve so that famine has a hard consequence.
- If `starved / P > 0.45`, trigger game-over revolt.
- Displays a starvation game-over advisor line.

### H64-061 — Depopulation loss
**Size:** XS · **Priority:** Must · **Status:** Not Started

As a player, I want the game to end if the city empties so that collapse is a loss state.
- If `PO%` falls below viability floor (e.g. < 20), trigger loss.
- Displays a depopulation advisor line.

### H64-062 — Upkeep-collapse loss
**Size:** S · **Priority:** Should · **Status:** Not Started

As a player, I want over-built collapse to end the game so that unsustainable building is punished.
- Buildings degraded to zero across consecutive unpaid years while population also falls triggers loss.

### H64-063 — Victory hold counter
**Size:** S · **Priority:** Must · **Status:** Not Started

As a player, I want a sustained-population victory so that a one-year fluke doesn't win.
- `HD%` increments each year `PO% >= TG%`; resets to 0 if below.
- Victory when `HD% >= HY%`.
- Displays victory advisor line.

### H64-064 — Resolution order lock
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want the end-of-turn steps executed in the exact spec order so that difficulty stays consistent.
- Order: tax → harvest → spoilage → events → upkeep → feeding → population → loss/victory check → advance year.
- Order covered by a documented test (Appendix C).

### H64-065 — Legacy rating / score
**Size:** M · **Priority:** Should · **Status:** Not Started

As a player, I want a score at game end so that I'm rated on how well I ruled.
- Computes score from target bonus, peak pop, years taken, buildings built, avg surplus, citizens starved.
- Maps score to a titled tier band with advisor flavor.

---

## Sprint 7 — Advisor Voice & Narrative Polish

### H64-070 — Advisor message system
**Size:** M · **Priority:** Must · **Status:** Not Started

As a developer, I want indexed advisor message arrays so that events print contextual flavor lines.
- Messages stored as DATA, read into string arrays by category.
- Random line picked per event for variety.
- Message selection indexes into a string array (not a computed GOTO), keeping all branching renumber-safe.

### H64-071 — Placeholder substitution
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want `{N}` / `{NAME}` placeholders filled at runtime so that messages report real numbers.
- Numeric/name values concatenated into printed strings.
- Verified for rat losses, immigration count, building completion.

### H64-072 — Yearly advisor report
**Size:** S · **Priority:** Must · **Status:** Not Started

As a player, I want a narrative summary each year so that the reign feels alive.
- Good vs poor harvest lines selected by yield.
- Event lines (rat, plague, flood, raid) appended when those fired.

### H64-073 — Non-fatal starvation warning
**Size:** XS · **Priority:** Should · **Status:** Not Started

As a player, I want a warning when people go hungry so that I get feedback short of game-over.
- Prints a starvation-warning line when `starved > 0` but below the revolt threshold.

---

## Sprint 8 — UI Enhancements & Threat Feedback

### H64-080 — THREAT indicator computation
**Size:** S · **Priority:** Should · **Status:** Not Started

As a player, I want a LOW/MED/HIGH threat indicator so that I sense scaling pressure without raw numbers.
- `TH%` derived from raid/plague pressure (0/1/2).
- Indicator text shown in buildings block.

### H64-081 — Color scheme & status color-coding
**Size:** S · **Priority:** Should · **Status:** Not Started

As a player, I want color-coded status so that warnings stand out.
- Resources white, warnings red/yellow, buildings cyan, narrative light green.
- THREAT shifts green → yellow → red with level.

### H64-082 — PETSCII panel framing
**Size:** S · **Priority:** Could · **Status:** Not Started

As a player, I want PETSCII box framing so that the panel looks polished.
- Box-drawing characters frame status/log/command zones.
- Layout still fits 40×25.

### H64-083 — Population progress bar
**Size:** S · **Priority:** Could · **Status:** Not Started

As a player, I want a progress bar toward the target so that I can track victory progress.
- Bar in status area scales with `PO% / TG%`.

---

## Sprint 9 — Difficulty & Cross-Platform

### H64-090 — Difficulty tiers
**Size:** M · **Priority:** Should · **Status:** Not Started

As a player, I want Easy/Standard/Hard tiers so that I can pick a challenge.
- Adjusts starting grain/pop, disaster frequency, base costs.
- Sets `TG%`/`HY%` per tier (600/2, 1000/3, 1500/3).

### H64-091 — PAL/NTSC compatibility check
**Size:** XS · **Priority:** Must · **Status:** Not Started

As a developer, I want no timing-sensitive code so that PAL and NTSC both run correctly.
- No raster/cycle-dependent timing in logic.
- Verified running in both VICE PAL (C64 PAL) and NTSC (C64 NTSC) machine models.

---

## Non-Functional Stories

### H64-100 — Integer rounding discipline
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want all stored/displayed state rounded to integers so that no fractional citizens or bushels appear.
- Floats used only for intermediate multipliers/ratios.
- All `%` variables rounded before storage/display.

### H64-101 — Memory budget within C64 RAM
**Size:** XS · **Priority:** Must · **Status:** Not Started

As a developer, I want the game to fit comfortably in C64 RAM so that it runs on real hardware.
- State is a few dozen variables plus small tables.
- No out-of-memory errors during a long reign.

### H64-102 — No-crash robustness
**Size:** S · **Priority:** Must · **Status:** Not Started

As a player, I want the game to never crash on any input so that a reign is never lost to a bug.
- All numeric prompts reject non-numeric, negative, and over-limit entries.
- Edge inputs (zero, max) handled without break/error.

### H64-103 — Balance tuning hooks
**Size:** XS · **Priority:** Should · **Status:** Not Started

As a developer, I want all balance values editable in one place so that playtesting tuning is fast.
- Tunable rates live as named constants (per H64-006).
- Changing a constant requires no formula edits.

### H64-104 — Save / load game state
**Size:** M · **Priority:** Could · **Status:** Not Started

As a player, I want to save and load my reign so that I can continue later.
- Writes ordered scalars + `BL%()` to disk (device 8) in fixed sequence.
- A single loop serializes and restores full state.
- Tested against a D64 disk image attached in VICE (device 8).
- Tape supported as lower priority.

### H64-105 — Readable, maintainable source
**Size:** XS · **Priority:** Should · **Status:** Not Started

As a developer, I want commented, conventionally-named code so that the project stays maintainable.
- Section/phase boundaries commented.
- Naming conventions from H64-002 followed throughout.
- A line-number map (which line range holds which routine) kept in a header REM block or project notes.

---

## Test / Validation Stories (Appendix C)

### H64-110 — Starvation game-over test
**Size:** XS · **Priority:** Must · **Status:** Not Started

As a developer, I want a test for the revolt threshold so that the loss fires correctly.
- Underfeeding above 45% triggers revolt; below does not.

### H64-111 — Victory-path test
**Size:** S · **Priority:** Must · **Status:** Not Started

As a developer, I want a test for sustained victory so that the hold counter behaves.
- Holding target for required years wins; a drop resets `HD%`.

### H64-112 — Upkeep-collapse test
**Size:** S · **Priority:** Should · **Status:** Not Started

As a developer, I want a test for the collapse condition so that degradation logic is verified.
- Over-building with insufficient grain degrades buildings and can fire collapse.

### H64-113 — Scarcity-curve test
**Size:** XS · **Priority:** Should · **Status:** Not Started

As a developer, I want a test for land price scaling so that scarcity and marketplace behave.
- Price rises with holdings; marketplace narrows the spread.

### H64-114 — Threat-indicator test
**Size:** XS · **Priority:** Could · **Status:** Not Started

As a developer, I want a test for the threat indicator so that LOW/MED/HIGH tracks the math.
- Indicator and color match underlying raid/plague pressure.

### H64-115 — Long-game balance test
**Size:** S · **Priority:** Should · **Status:** Not Started

As a developer, I want a turtle-strategy test so that coasting isn't dominant.
- Confirms scaling pressures make indefinite safe play non-viable once tuned.

---

## Open Questions to Resolve During Planning (Appendix D)
- One build action per year vs unlimited construction (affects H64-024 pacing).
- Whether save/load (H64-104) ships in the first version.
- Final tuning values for all formulas (first-pass numbers in spec).
- Exact event-table contents and advisor copy.
