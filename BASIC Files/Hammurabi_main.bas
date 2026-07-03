!- Hammurabi : Ancient Civilization

!- **************************************************************************
!- * Variable Naming Convention (H64-002)
!- * BASIC V2 reads only the first 2 characters of a variable name, so every
!- * name below must be unique within its first two letters.
!- *
!- *   XX%   integer  - whole-number game state (people, bushels, acres, levels)
!- *   XX    float    - multipliers, prices, ratios needing fractions
!- *   XX$   string   - messages, names
!- *
!- * Avoid reserved words inside the first two characters, e.g. not:
!- *   TO  IF  ON  OR  FN
!- *
!- * Prefix registry - first 2 chars reserved by planned variables (spec Sec.10).
!- * Check new names against this list before adding one; extend as declared.
!- *
!- *   Core state (scalars):
!- *     YR  PO  GR  LA  PR  PL  FE  ST  BI  IM  DE  HV  HD
!- *   Building arrays:
!- *     BL  BC  BU  BN
!- *   Derived / per-turn working variables:
!- *     YP  SC  DN  PC  RC  UP  AD  TH
!- *   Constants:
!- *     TG  HY  SE  EA  WK  BR  DR  TX  SR
!- **************************************************************************
