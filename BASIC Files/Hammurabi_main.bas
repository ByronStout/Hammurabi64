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

!- **************************************************************************
!- * Building Levels Array (H64-004)
!- * DIM BL%(7) - building levels, index 0-7. Numeric arrays are auto-zeroed
!- * by BASIC V2 on DIM, so all levels start at 0.
!- *
!- *   0 = Irrigation   1 = Granary      2 = City Walls   3 = Levees
!- *   4 = Aqueduct     5 = Temple       6 = Marketplace  7 = Tax Office
!- **************************************************************************

100 rem *** game initialization (100-190) ***
110 rem *** core scalar state - h64-003 ***
120 yr%=1:po%=95:gr%=2800:la%=1000:pr%=0
130 pl%=0:fe%=0:st%=0:bi%=0:im%=0
140 de%=0:hv%=0:hd%=0

145 rem *** building level array - h64-004 ***
146 dim bl%(7)
