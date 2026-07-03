# Hammurabi C64 Variant — Game Specification

> **Status:** Draft v1.8 — Formula verification pass; mitigation caps, upkeep/variable reconciliation
> **Platform:** Commodore 64
> **Document owner:** _(your name)_
> **Last updated:** _(date)_

---

## 1. Overview

- **Working title:** Hammurabi 64 (final title TBD)
- **Concept:** A single-player, turn-based resource-management game in which you rule an ancient river city-state, allocating grain, land, and population to survive and grow — extended with a permanent **building** system that adds a long-term construction arc to the classic survival loop.
- **Genre:** Turn-based resource management / strategy.
- **Target platform:** Commodore 64, written in BASIC V2 (PAL and NTSC; no timing-sensitive code, so both are supported).
- **Inspiration:** The classic *Hammurabi* (*The Sumer Game*). This variant differs by adding permanent buildings across four tracks, an open-ended reign with a sustained population-target victory, and scaling-pressure mechanics that make a larger city harder to hold (see Sections 2, 5, 6).
- **Player role:** The ruler ("Hammurabi") of the city-state, advised each year by a wry steward.

## 2. Game Concept & Theme

### Setting & Narrative Framing
You rule an ancient city-state along a great river. As in classic Hammurabi, you allocate grain, land, and population each year and survive the whims of harvest, rats, and plague. Grain is the universal currency — it is simultaneously food, seed, and money.

### Variant Hook: Technology & Building
The defining departure from the original is **permanent construction**. Each year, in addition to the classic buy-land / plant / feed decisions, you may invest grain into **buildings** that permanently alter the rules of the simulation. Where classic Hammurabi is a pure turn-to-turn survival loop with no memory between years, this variant adds a **build-up arc**: early sacrifice for long-term strength.

The central tension: every bushel spent on construction is a bushel not feeding your people or planted as seed. Over-investing risks famine *now*; under-investing leaves you fragile to the disasters of later years. Buildings also require upkeep, so an over-built city you cannot maintain will crumble.

Buildings span several improvement tracks:
- **Agricultural** (irrigation, granaries) — raise yield and reduce spoilage
- **Protective** (walls, levees) — reduce losses from disasters
- **Civic** (aqueduct, temple) — improve population growth and morale
- **Economic** (marketplace, tax office) — improve land trade and generate grain income

### Win / Loss Philosophy & Tone
The tone follows the original's wry, judgmental advisor voice. Victory is measured not just by survival but by what you *built* — a city that endures and prospers across a full reign. Failure remains swift and unforgiving: mass starvation or revolt ends the game. The rating screen rewards players who balanced growth, investment, and survival rather than hoarding.

## 3. Core Gameplay Loop

### Turn Structure
One turn = one year. The reign continues year after year (open-ended) until victory or a loss condition is met.

### Sequence of a Turn
1. **Display status** — the panel shows current year, population, grain, land, price, buildings, upkeep, and threat level (Section 7).
2. **Advisor report** — narrative summary of the year just resolved (first turn shows a greeting instead).
3. **Player decisions** — in any order: buy/sell land, construct or upgrade buildings, feed the population, and choose acreage to plant (Section 4).
4. **End Year** — the player confirms, triggering resolution.

### End-of-Turn Resolution (order matters)
1. Collect **Tax Office** income (if built).
2. Compute **harvest** from planted acres and yield.
3. Apply **rat spoilage** to stored grain.
4. Roll **random events**: determine whether flood, raid, and plague fire this year (using the size-scaled chances), and apply grain/land losses from flood and raid.
5. Deduct **upkeep** (building upkeep + admin overhead); degrade a building if unpaid.
6. Resolve **feeding**: subtract grain eaten, compute `starved`.
7. Update **population**: add births and immigration, subtract deaths (baseline + plague, if plague fired in step 4) and `starved`.
8. Check **loss conditions**, then **victory** (and the hold counter).
9. Advance the year and loop.

> The resolution order is deliberate and should be locked early, since changing it (e.g., feeding before or after events) measurably shifts difficulty. Note that plague is split: whether it *fires* is rolled in step 4, but the resulting deaths are applied with the rest of population change in step 7. It is a candidate for the test cases in Appendix C.

## 4. Game Mechanics

### Resources
| Resource | Role |
|---|---|
| **Grain (bushels)** | Universal currency: food, seed, and money for land and buildings |
| **Land (acres)** | Determines how much can be planted; bought/sold each year |
| **Population (people)** | Workforce; each person plants a limited acreage and eats grain |
| **Buildings** | Permanent improvements; persist year to year (NEW) |

### Player Decisions (per turn)
1. Buy or sell land (at the year's fluctuating price)
2. **Construct or upgrade buildings** (NEW)
3. Allocate grain to feed the population
4. Choose acreage to plant (limited by people, land, and seed grain)

> Note: the Tax Office (Economic) generates grain automatically each year and requires no player action — its income is collected during year-end resolution.

### Buildings (the variant system)
Each building has a **grain cost** to construct, an optional **upgrade path** (levels), and an annual **upkeep** in grain. Effects are permanent while upkeep is paid; if upkeep is unmet, the building degrades one level.

| Building | Track | Effect | Base Cost | Upkeep/yr |
|---|---|---|---|---|
| **Irrigation canals** | Agricultural | +0.5 bushels yield per acre per level | 800 | 40 |
| **Granary** | Agricultural | Halves rat-spoilage per level (cap ~90%) | 600 | 20 |
| **City walls** | Protective | Reduce raid/disaster grain loss by 20% per level | 1000 | 30 |
| **Levees** | Protective | Reduce flood damage by 30% per level | 700 | 25 |
| **Aqueduct** | Civic | +25% population growth, −plague chance | 900 | 35 |
| **Temple** | Civic | Reduces unrest; small morale bonus to growth | 500 | 15 |
| **Marketplace** | Economic | Narrows land buy/sell spread; better prices | 750 | 30 |
| **Tax Office** | Economic | Yearly grain income scaling with population | 850 | 35 |

(Costs and effects above are first-pass values for balancing in Section 5.)

### Economy
- Land price fluctuates yearly (classic 17–26 bushels/acre range), narrowed by a Marketplace.
- The Tax Office generates grain income each year scaled to population (tribute/taxes), collected at year-end — a passive reward for the population growth the player is chasing for victory.
- Building costs scale per upgrade level (see Section 5).
- Upkeep is deducted at year-end before harvest accounting.

### Random Events
- Harvest variance (good/poor yield multiplier)
- Rat infestation (spoilage — mitigated by Granary)
- Plague (population loss — mitigated by Aqueduct)
- Flood (grain/land loss — mitigated by Levees)
- Raids (grain/population loss — mitigated by City walls)

### Population Dynamics
- Growth from surplus grain and civic buildings
- Immigration scaling with prosperity
- Deaths from starvation (unfed population) and plague
- Starvation above a threshold (e.g., 45% in one year) triggers game-over revolt

## 5. Formulas & Balancing

Notation: `P` = population, `L` = land (acres), `G` = grain (bushels), `A` = acres planted. Building levels are referred to by short tags: `irr` (irrigation), `gran` (granary), `wall` (city walls), `lev` (levees), `aqu` (aqueduct), `tmp` (temple), `mkt` (marketplace), `tx` (tax office) — in code these are the elements of the `BL%()` array from Section 10 (e.g., `irr` = `BL%(0)`), and `P`/`L`/`G` map to the scalars `PO%`/`LA%`/`GR%`. The formulas below are written as readable pseudocode; use the Section 10 variable names in the actual BASIC.

### Harvest Yield
```
base_yield  = RND(1..6)                      ' bushels per acre, classic
yield/acre  = base_yield + 0.5 * irr         ' irrigation bonus
harvest     = A * (yield/acre)
```

### Rat Spoilage (Granary)
```
spoil_rate  = (RND chance) * 0.5^gran         ' each granary level halves loss
                                              ' effective cap ~90% reduction
grain_lost  = G * spoil_rate
```

### Planting Limits
```
max_by_people = P * WK         ' each person works up to WK (=10) acres
max_by_seed   = G / SE         ' SE (=0.5) bushel seed per acre
max_by_land   = L
A_max = MIN(max_by_people, max_by_seed, max_by_land)
```

### Births & Immigration
Population gain has two distinct sources, computed during the population-update step — *after* feeding is resolved (see the end-of-turn order in Section 3), so `fed` is already known.

**Births (internal growth)** — existing people reproduce, but only if the city is fed; civic buildings boost morale and family growth.
```
fed_ratio  = fed / P                          ' 0..1, from the Starvation block (computed earlier this turn)
births     = INT( P * 0.03 * fed_ratio )      ' ~3% base birth rate, scaled by feeding
```
A fully fed city grows internally by roughly 3% a year; a half-starved one by half that. A city that fed no one has no births.

**Immigration (external arrivals)** — outsiders are drawn by prosperity but deterred by crowding, so a packed city with no spare land attracts few newcomers.
```
prosperity   = G + (L * 20) + (P * 5)         ' same measure used by raid escalation
room         = MAX(0, 1 - density/10)         ' density = P/L; full at 10 people/acre
immigration  = INT( (prosperity / 4000) * room )
```
The `room` term ties immigration to your land holdings: keep buying land as you grow, or arrivals dry up (and plague risk climbs — see Scaling Pressure). Immigration falls to zero once density reaches ~10 people per acre. (Note: the plague formula scales on `density/8` rather than `density/10` — the two thresholds are intentionally different, so plague pressure ramps up *before* immigration fully chokes off. Align them if you'd prefer a single density breakpoint.)

> **Balance check:** with the suggested `4000` divisor, immigration is small relative to births at typical mid-game states (e.g. P=500, L=400, G=2000 yields ~2 immigrants vs ~15 births). That's intentional — births should be the main growth engine and immigration a prosperity bonus — but if you want immigration to matter more, lower the divisor. Verify the balance during the playtests in Appendix C.

### Population Growth (Aqueduct + Temple)
```
growth_base = INT( births * (1 + 0.25*aqu) * (1 + 0.05*tmp) )
new_pop     = P + growth_base + immigration - deaths - starved
```
> `growth_base` applies civic-building bonuses to **births** only (immigrants arrive independent of those buildings). `deaths` (baseline + plague, defined below) and `starved` (from the Starvation block) are kept as separate subtractions so they are never double-counted. All four terms feed the `new_pop` update.

### Deaths (baseline mortality + plague)
`deaths` covers ordinary mortality plus losses from a plague event in the same year. Starvation is **not** included here — it is subtracted separately in `new_pop` above.
```
base_deaths   = INT( P * 0.02 )                  ' ~2% ordinary annual mortality
plague_deaths = 0
IF plague_strikes THEN plague_deaths = INT( P * (0.10 + RND*0.15) * MAX(0, 1 - 0.15*aqu) )
                                                 ' 10-25% hit, reduced by Aqueduct (floored at 0)
deaths        = base_deaths + plague_deaths
```
A baseline ~2% of the population dies each year regardless. When a plague event fires (its chance set by the density-driven `plague_chance` under Scaling Pressure), it kills a further 10–25% of the population, blunted by the Aqueduct. With no plague in a given year, `deaths` is just the baseline.

> Note: the Aqueduct helps against plague twice, by design — it lowers how *often* plague strikes (via `plague_chance`) and how *many* die when it does (the severity term here). This makes it the key civic investment for a large, dense city. Tune one or both coefficients down if it proves too strong in playtesting.

### Starvation
```
fed         = INT( G_allocated / EA )     ' EA (=20) bushels feeds 1 person/year
starved     = MAX(0, P - fed)
IF starved / P > 0.45 THEN game_over_revolt
```

### Land Price (Marketplace narrows spread)
```
price       = 17 + RND(0..9)             ' classic 17..26 base price
spread_adj  = MAX(0.5, 1 - 0.10*mkt)     ' marketplace narrows buy/sell gap (floored)
```
This gives the base price and the marketplace adjustment. The `MAX(0.5, ...)` floor keeps the marketplace from reducing the price below half (and prevents it going to zero or negative at high levels). The **full** buy price also multiplies in the land-scarcity factor — see the complete `buy_price` formula under **Scaling Pressure** below. (This block and the Scaling Pressure block describe the same price; the version below is authoritative.)

### Tax Income (Tax Office)
```
' Collected at year-end if tx >= 1 (Tax Office built)
tax_income = INT( P * 0.5 * tx )         ' bushels per year, scales with population
                                         ' and per Tax Office level (tx)
G = G + tax_income
```
The Tax Office turns a large population into a steady grain income, representing tribute and taxes. It needs no player action — income is collected automatically during year-end resolution. Because it scales with population, it rewards the growth the player is already pursuing for victory, while its upkeep and the diminishing value of grain in a well-stocked city keep it from being a runaway engine. Generates no income if upkeep is unpaid and the building has degraded to level 0.

### Disaster Mitigation
Buildings reduce the damage from random events. Base effects:
```
flood_loss    = base_flood * MAX(0, 1 - 0.30*lev)
plague_chance = base_plague * MAX(0, 1 - 0.15*aqu)
```
> **Cap required:** the `(1 - k*level)` mitigation terms must be floored at 0 (shown via `MAX(0, ...)`), otherwise a high enough building level drives the loss negative — e.g. without the floor, `lev >= 4` would make a flood *add* grain. The same `MAX(0, ...)` floor applies to the wall term in raid_loss below. Effective mitigation therefore caps at 100% (levees fully negate floods at level 4+, aqueduct fully negates plague chance at level 7+, walls fully negate raid loss at level 5+). If full immunity is undesirable, switch these to a multiplicative form like `0.70^lev` (as the Granary already uses) so mitigation asymptotes toward but never reaches 100%.
> Raid and plague are further modified by city size — see the `raid_chance` / `raid_loss` and density-driven `plague_chance` formulas under **Scaling Pressure** below, which are the authoritative versions. `base_plague` and `base_raid` are the unmodified base loss/severity rates set per difficulty.

### Building Cost Scaling (per upgrade level)
```
cost(level) = base_cost * (1.5 ^ (level - 1))   ' each level 50% pricier
```

### Upkeep (deducted at year-end)
```
building_upkeep = SUM(level * upkeep_per_level for each building)
' admin_cost is added to this — see Scaling Pressure #2 below
total_upkeep    = building_upkeep + admin_cost
IF G < total_upkeep THEN degrade one building by 1 level
```
> `building_upkeep` is the per-building portion; `total_upkeep` adds the population-scaled `admin_cost` defined under Scaling Pressure #2. The two are combined into a single deduction at year-end.

### Difficulty Scaling
- Adjust starting grain/population, disaster frequency, and base costs by difficulty tier.
- Higher tiers: lower base yields, costlier buildings, more frequent raids/floods.

### Scaling Pressure (anti-turtle mechanics)
Because the reign is open-ended, these mechanics make a larger, longer-lived city progressively harder to sustain — so "play it safe indefinitely" is never a free strategy. Each scales with your success, raising the stakes as you approach the population target.

**1. Land scarcity — price climbs with holdings**
```
scarcity   = 1 + (L / 2000)              ' more land owned = pricier expansion
buy_price  = (17 + RND(0..9)) * scarcity * MAX(0.5, 1 - 0.10*mkt)
```
The easy fertile land is claimed first; further growth costs progressively more. (The `MAX(0.5, ...)` floor on the marketplace term matches the Land Price block above.)

**2. Administrative overhead — baseline upkeep grows with the city**
```
admin_cost = INT(P / 100) * 10            ' 10 bushels per 100 citizens/yr
                                          ' added to building_upkeep -> total_upkeep (see Upkeep block)
```
A sprawling city bleeds grain simply by existing, independent of buildings.

**3. Raid escalation — wealth attracts raiders**
```
prosperity   = G + (L * 20) + (P * 5)                    ' same measure as immigration
raid_chance  = base_raid_chance + (prosperity / 50000)   ' richer = bigger target
raid_loss    = base_raid * (1 + prosperity/40000) * MAX(0, 1 - 0.20*wall)
```
Walls shift from optional to essential as the city grows. (`raid_chance` is the probability the event fires; `base_raid` is the loss magnitude if it does — two distinct base values. The `MAX(0, ...)` floor caps wall mitigation at 100%, reached at `wall = 5`.)

**4. Crowding plague risk — density drives disease**
```
density        = P / MAX(L, 1)            ' people per acre
plague_chance  = base_plague * (1 + density/8) * MAX(0, 1 - 0.15*aqu)
```
Growing population forces continued land purchases *and* aqueduct investment, not just food.

> **Balancing note:** these four pressures should be tuned so the target is reachable but never trivial — the player must keep investing (land, walls, aqueducts) right up to and through the 3-year hold, rather than coasting.

## 6. Win & Loss Conditions

### Reign Structure
The reign is **open-ended** — there is no fixed number of years. You rule until you either achieve victory or your city collapses. This gives building investments time to compound and rewards long-term planning over short-term survival.

### Victory: Population Target (Sustained)
The primary goal is to grow and **sustain** a target population.

```
TARGET_POP = 1000                 ' tunable per difficulty (= TG% in Section 10)
HOLD_YEARS = 3                    ' must sustain for this many consecutive years (= HY%)

IF P >= TARGET_POP for HOLD_YEARS consecutive years THEN victory
```

The "hold" requirement prevents a one-year immigration fluke from triggering a win — the city must prove it can feed and stabilize that population across multiple harvests, which in turn forces investment in agricultural and civic buildings. A counter resets to zero if population drops below target in any year.

Suggested difficulty targets:

| Difficulty | Target Pop | Hold Years |
|---|---|---|
| Easy | 600 | 2 |
| Standard | 1000 | 3 |
| Hard | 1500 | 3 |

### Loss Conditions
- **Starvation revolt** — more than 45% of the population starves in a single year (classic Hammurabi failure).
- **Depopulation** — population falls below a minimum viability floor (e.g., < 20 people).
- **Collapse from upkeep** — buildings degrade to zero across consecutive years of unpaid upkeep while population also falls, signalling an over-built city that cannot sustain itself.

### Legacy Rating (Scoring)
Even after victory, the player is rated on *how well* they ruled — preserving replay incentive to win more efficiently. Score factors:

```
score = (TARGET_POP_reached_bonus)
      + (peak_population)
      - (years_taken * time_penalty)
      + (buildings_constructed * build_bonus)
      + (avg_grain_surplus * efficiency_bonus)
      - (total_citizens_starved * starvation_penalty)
```

The rating screen retains the original's wry advisor voice — e.g., judging whether you ruled as a wise builder-king or a tyrant who starved his people on the road to a monument-filled city. Tiers (sample):

| Score band | Title |
|---|---|
| Top | "Hammurabi the Great — your city is a wonder of the age" |
| High | "A wise and prosperous ruler" |
| Mid | "A competent steward; the people endured" |
| Low | "The granaries stood, but so did the graves" |

## 7. User Interface

### Display Constraints
The C64 text screen is **40 columns × 25 rows**. The original Hammurabi was pure scrolling text, but this variant tracks more state (buildings, upkeep, scaling pressures) that the player must see at a glance. The chosen approach is a **fixed status panel plus a scrolling interaction zone** — persistent vital numbers up top, year events and prompts below.

### Screen Layout (primary play screen)
```
+--------------------------------------+
| HAMMURABI 64        YEAR 7  POP 842  |  status bar (rows 1-2)
+--------------------------------------+
| GRAIN 3,210   LAND 980a   PRICE 23/a |  resources (rows 3-5)
| FED 800/842   PLANT 540a  SEED 270   |
+--------------------------------------+
| BUILDINGS  Irr2 Gran1 Wall2 Aqu1     |  buildings (rows 6-8)
| UPKEEP 215   ADMIN 80   THREAT: MED  |
+--------------------------------------+
| > A poor harvest! Rats took 340.     |  event/report log
|   Raiders eye your wealth...         |  (rows 9-20, scrolls)
|                                      |
|                                      |
+--------------------------------------+
| BUY/SELL  BUILD  PLANT  END YEAR     |  command line (rows 22-24)
| Your command? _                      |
+--------------------------------------+
```

### Panel Contents
- **Status bar** — game title, current year, current population (the victory metric, always visible).
- **Resources block** — grain, land owned, current land price, fed/total ratio, acres planted, seed used.
- **Buildings block** — abbreviated building levels, total upkeep, admin overhead, and a **THREAT** indicator (LOW/MED/HIGH) summarizing the scaling-pressure state (raid risk, plague density) without numbers.
- **Event/report log** — the scrolling narrative zone; the advisor's wry voice lives here.
- **Command line** — verb menu and input prompt.

### Interaction Flow
- Top-level **verb menu** (Buy/Sell, Build, Plant, End Year). Selecting a verb opens a brief sub-prompt sequence in the log area rather than a whole new screen — keeping the status panel visible throughout.
- **Build** lists available buildings, current level, next-level cost, and effect, then asks which to construct/upgrade.
- **End Year** triggers resolution: harvest, events, upkeep deduction, population update — each reported as lines appended to the log.

### Input & Validation
- Numeric entry for amounts (land, grain to plant/feed, building spend).
- Reject impossible commands (overspending grain, planting beyond people/land/seed limits) with an advisor rebuke rather than a crash — e.g., "My lord, we have not the grain!"
- Confirm the irreversible **End Year** before resolving.

### Color Scheme (C64 16-color palette)
- Classic C64 dark-blue background, light-blue border (the iconic default), or a custom black/ochre "ancient" palette for theme.
- Color-code status: grain/resources in white, warnings (low food, high threat) in red/yellow, building info in cyan, advisor narrative in light green.
- THREAT indicator color shifts LOW (green) → MED (yellow) → HIGH (red).

### Optional Visual Enhancements
- **PETSCII** framing characters for the panel boxes (already implied by the layout sketch).
- A simple **PETSCII city skyline** that grows as buildings are constructed — cheap, characterful feedback on progress.
- Optional **sprite** banner on the title screen.
- A small **population bar/chart** in the status area showing progress toward the target.

## 8. Audio

**Out of scope.** This project intentionally ships without sound. No SID music or sound effects are planned. (Could be revisited as a stretch goal — see Section 11.)

## 9. Technical Specification

### Language
The game is written entirely in **Commodore BASIC V2**. The logic is turn-based arithmetic, text output, and input prompts — no real-time action, animation, or tight timing — so BASIC's performance is never a constraint here.
- Performance is a non-issue for turn-based math and text; BASIC's slowness never bites in this design.
- Developer is fluent in BASIC → rapid development, with energy spent on design and balancing rather than fighting the tooling.
- Built-in floating point handles the fractional formulas (`0.5*irr`, density ratios) directly, with no need for fixed-point workarounds.

### Numeric Approach
- Use native floating point for the fractional multipliers (yield bonuses, scarcity, density).
- Round to integers for all stored and displayed state — people, bushels, acres, building levels (see the `%` integer convention in Section 10).

### Random Number Approach
- Use `RND()` seeded from a changing hardware source (e.g., a CIA timer or raster value captured at the first keypress) so games are not identical run to run.

### Memory / RAM Budget
- Ample headroom: game state is only a few dozen variables plus small tables (Section 10). No memory concerns are expected.

### Save / Load
- Optional. If included, save game state to disk (device 8) — a single record of the state variables in Section 10.
- Tape is supported but lower priority; disk is the primary target.

### Build / Dev Toolchain
- **VICE** emulator for development and testing (warp mode for fast iteration).
- Optionally cross-develop: edit the program on a modern machine and run it in VICE.
- Target a real or emulated C64; PAL vs. NTSC differences are not a concern for this non-timing-sensitive design.

## 10. Data Structures (BASIC V2)

### Naming Constraints
BASIC V2 recognizes only the **first 2 characters** of a variable name, so all names below are unique within their first two letters. Conventions used:
- `XX%` = integer (whole-number game state — people, bushels, acres, levels)
- `XX`  = floating point (multipliers, prices, ratios needing fractions)
- `XX$` = string (messages, names)
- Avoid BASIC reserved words inside the first two characters (e.g., not `TO`, `IF`, `ON`, `OR`, `FN`).

> Use integer variables (`%`) for all countable state — they're faster and reflect that you can't have a fractional citizen or bushel. Reserve floats for prices and multiplier math, rounding to integer before storage/display.

### Core State Variables (scalars)
| Var | Type | Meaning |
|---|---|---|
| `YR%` | int | Current year (turn counter) |
| `PO%` | int | Population |
| `GR%` | int | Grain in store (bushels) |
| `LA%` | int | Land owned (acres) |
| `PR%` | int | Current land price (bushels/acre) |
| `PL%` | int | Acres planted this year |
| `FE%` | int | People fed this year |
| `ST%` | int | People starved this year |
| `BI%` | int | Births this year (internal growth) |
| `IM%` | int | Immigrants this year (external arrivals) |
| `DE%` | int | Deaths this year (baseline + plague) |
| `HV%` | int | Harvest yield this year (bushels) |
| `HD%` | int | Consecutive years at/above target (victory hold counter) |

### Building Levels (array)
A single array holds all building levels, indexed by a fixed constant scheme:
```
DIM BL%(7)        ' building levels, index 0-7
' 0 = Irrigation   1 = Granary    2 = City Walls   3 = Levees
' 4 = Aqueduct     5 = Temple     6 = Marketplace   7 = Tax Office
```
Parallel constant arrays (read from DATA) hold each building's economics:
```
DIM BC%(7)        ' base construction cost
DIM BU%(7)        ' upkeep per level
DIM BN$(7)        ' display name
```

### Derived / Per-Turn Working Variables
These are recomputed each turn. Most are floating point (multipliers and ratios); the upkeep/threat values are integers, as marked.
| Var | Type | Meaning |
|---|---|---|
| `YP` | float | Yield per acre (incl. irrigation bonus) |
| `SC` | float | Land scarcity multiplier |
| `DN` | float | Population density (people/acre) |
| `PC` | float | Plague chance this year |
| `RC` | float | Raid chance this year |
| `UP%` | int | Total upkeep due (buildings + admin) |
| `AD%` | int | Admin overhead this year |
| `TH%` | int | Threat level 0=LOW 1=MED 2=HIGH (for status display) |

### Tables via DATA (read once at startup)
- **Building economics** → `BC%()`, `BU%()`, `BN$()` populated from `DATA` lines.
- **Event messages** → string array of advisor lines, indexed by event code.
- **Rating tiers** → score thresholds and title strings for the end screen.

```
' Example: building economics DATA (cost, upkeep, name)
DATA 800,40,"IRRIGATION"
DATA 600,20,"GRANARY"
DATA 1000,30,"CITY WALLS"
DATA 700,25,"LEVEES"
DATA 900,35,"AQUEDUCT"
DATA 500,15,"TEMPLE"
DATA 750,30,"MARKETPLACE"
DATA 850,35,"TAX OFFICE"
```

### Constants (set once)
| Var | Type | Meaning | Suggested value |
|---|---|---|---|
| `TG%` | int | Target population for victory | 1000 |
| `HY%` | int | Years to hold target | 3 |
| `SE` | float | Seed grain per acre | 0.5 |
| `EA%` | int | Eaten per person per year | 20 |
| `WK%` | int | Acres one person can work | 10 |
| `BR` | float | Base birth rate (fully fed) | 0.03 |
| `DR` | float | Base annual mortality rate | 0.02 |
| `TX` | float | Tax income per person per Tax Office level | 0.5 |
| `SR` | float | Starvation revolt threshold (fraction) | 0.45 |

> Gathering the tunable rates here (rather than burying them as literals in the formulas) makes balancing a single-location edit. The formula blocks in Section 5 show these as literal values for readability; in code, reference the constant.

### Save/Load Record (if implemented)
The save file is simply the ordered set of scalars plus the `BL%()` array — written to and read from disk in a fixed sequence so a single loop can serialize/restore the full game state.

---

## 10A. Advisor Messages

The advisor is the player's wry, faintly long-suffering voice of counsel — the personality that the original Hammurabi delivered in terse one-liners. Messages below are grouped by trigger so they can be stored as indexed string arrays (or `DATA` lines per Section 10) and selected by event code. Lines are kept short to fit the 40-column event log; where several are listed for one situation, pick at random for variety.

### Game Start / Greeting
- "My liege, the city looks to you. Rule wisely."
- "A new reign begins. The granaries await your hand."
- "Speak your will, and Sumer shall obey."

### Yearly Report — Good Harvest
- "A bountiful year! The storehouses groan with grain."
- "The river was kind. We harvested well, my lord."
- "Such plenty! The people sing your name at supper."

### Yearly Report — Poor Harvest
- "A meager harvest, my liege. Tighten the belts."
- "The fields disappointed. We must make do."
- "Lean times ahead — the granary is thinner than we'd hoped."

### Rat Infestation
- "Rats! They feasted on {N} bushels while we slept."
- "Vermin in the stores, my lord — {N} bushels lost."
- "The granary cats failed us. {N} bushels gone to rats."

### Plague
- "Plague stalks the streets. We have lost many souls."
- "Sickness spreads in the crowded quarters, my liege."
- "The healers are overwhelmed. Pray this passes."

### Flood
- "The river burst its banks! Grain and land are lost."
- "Floodwaters have ruined the lowland stores, my lord."
- "The levees strained — the waters took their due."

### Raid
- "Raiders struck in the night and carried off our grain!"
- "Marauders test our walls, my liege. We are bled."
- "Bandits grow bold as our wealth grows, my lord."

### Population Growth / Immigration
- "Word of your prosperity spreads — newcomers arrive."
- "The city swells; {N} souls have joined us this year."
- "Families flourish under your rule, my liege."

### Building Completed
- "It is done, my lord. The {NAME} stands complete."
- "The masons have finished the {NAME}. A fine work."
- "The {NAME} rises over the city — a lasting monument."

### Upkeep Trouble
- "We cannot pay to maintain all you have built, my liege."
- "The {NAME} falls into disrepair — the coffers ran dry."
- "Over-built and under-fed, my lord. Something must give."

### Threat Level Rising
- "Our riches draw hungry eyes. Strengthen the walls."
- "The city grows crowded and watched, my liege. Beware."

### Invalid / Rejected Input
- "My lord, we have not the grain for such a thing!"
- "We cannot plant what we cannot sow — too few hands."
- "That land is not ours to give, my liege."
- "I cannot do as you ask. Reconsider, great one."

### Starvation Warning (non-fatal)
- "The people went hungry this year. They will remember."
- "Empty bellies breed empty loyalty, my lord."

### Game Over — Starvation Revolt
- "You have starved your people! They rise against you."
- "The mob storms the palace. Your reign ends in famine."

### Game Over — Depopulation
- "The city stands all but empty. Your reign withers away."

### Victory — Target Sustained
- "The city thrives and endures! Your name will outlast stone."
- "A thousand souls and more, held strong. You have triumphed, great Hammurabi!"

> **Implementation note:** placeholders like `{N}` and `{NAME}` are filled at runtime by concatenating the relevant variable into the printed string. Storing each category as a small `DATA` block and reading into a string array lets the game pick a random line per event with a simple index.

---


## 11. Stretch Goals / Optional Features

Features deliberately deferred from the core build, roughly in order of value-to-effort:

- **High score / legacy table** — persist top reigns (score, peak population, years) to disk so results carry between sessions. Pairs directly with the Section 6 rating system.
- **Multiple scenarios / difficulty modes** — the Easy/Standard/Hard targets from Section 6, plus optional themed starts (e.g., "drought era" with lower base yields, "border city" with heavier raids).
- **Growing PETSCII city skyline** — a visual that gains structures as buildings are constructed (per Section 7); cheap, high-character payoff that the text-only original never had.
- **Audio** — SID music and sound effects, deferred from Section 8.
- **Two-player / hotseat** — rival rulers alternating turns, or competing for the same finite land pool.
- **Random map / starting conditions** — vary initial grain, land, and price each game for replayability.
- **Events expansion** — a deeper random-event table (trade caravans, royal weddings, omens) feeding the advisor narrative.

## 12. Appendices

### Appendix A — Glossary
| Term | Meaning |
|---|---|
| **Bushel** | Unit of grain; the universal currency (food, seed, money) |
| **Acre** | Unit of land; limits how much can be planted |
| **Upkeep** | Annual grain cost to maintain buildings |
| **Admin overhead** | Baseline grain cost that scales with population |
| **Hold counter** | Consecutive years at/above target population (`HD%`) |
| **Scarcity multiplier** | Factor raising land price as holdings grow |
| **Density** | People per acre; drives plague risk |
| **Threat level** | LOW/MED/HIGH summary of raid + plague pressure |
| **PETSCII** | The C64's extended character set, used for framing and the skyline |

### Appendix B — Reference: Classic Hammurabi
The 1968 mainframe game *The Sumer Game* (later *Hammurabi*, 1973, and widely ported to BASIC) is the ancestor. Core loop retained by this variant:
- Grain serves as food, seed, and money simultaneously.
- Each year: buy/sell land, feed people, choose acres to plant.
- Random harvest, rat spoilage, and plague.
- Game over if too large a share of the population starves.

This variant departs by adding **permanent buildings** (Section 2), an **open-ended reign with a sustained population goal** (Section 6), and **scaling pressures** that make a larger city harder to hold (Section 5).

### Appendix C — Test Cases / Playtesting Notes
Scenarios to validate during balancing:
1. **Starvation game-over** — deliberately underfeed; confirm revolt triggers above the 45% threshold.
2. **Victory path** — confirm reaching and holding the target for the required years triggers victory, and that dropping below resets the hold counter.
3. **Upkeep collapse** — over-build with insufficient grain; confirm buildings degrade and the collapse loss condition can fire.
4. **Scarcity curve** — verify land price rises sensibly as holdings grow, and the marketplace meaningfully narrows the spread.
5. **Threat indicator** — confirm LOW/MED/HIGH tracks the underlying raid/plague math and color-codes correctly.
6. **Edge inputs** — reject overspending grain, planting beyond people/land/seed limits, and negative entries without crashing.
7. **Long-game balance** — confirm turtling indefinitely is not a dominant strategy once scaling pressures are tuned.

### Appendix D — Open Questions / To Decide
- Final tuning values for all formulas (current numbers are first-pass).
- Whether one building action per year or unlimited construction (affects pacing).
- Whether save/load ships in the first version.
- Exact event table contents and advisor message copy.
