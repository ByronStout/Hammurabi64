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
!- *     YP  SC  DN  PC  RC  UP  AD  TH  OV
!- *   Constants:
!- *     TG  HY  SE  EA  WK  BR  DR  TX  SR
!- *   Utility / scratch (keypress buffer, RND seed throwaway, loop index):
!- *     KY  X   BG
!- **************************************************************************

!- **************************************************************************
!- * Building Levels Array (H64-004)
!- * DIM BL%(7) - building levels, index 0-7. Numeric arrays are auto-zeroed
!- * by BASIC V2 on DIM, so all levels start at 0.
!- *
!- *   0 = Irrigation   1 = Granary      2 = City Walls   3 = Levees
!- *   4 = Aqueduct     5 = Temple       6 = Marketplace  7 = Tax Office
!- **************************************************************************

10 rem *** rng seed capture (10-90) - h64-007 ***
20 print "press any key to begin"
30 get ky$:if ky$="" then 30
40 x=rnd(-ti)

100 rem *** game initialization (100-190) ***
110 rem *** core scalar state - h64-003 ***
120 yr%=1:po%=95:gr%=2800:la%=1000:pr%=0
130 pl%=0:fe%=0:st%=0:bi%=0:im%=0
140 de%=0:hv%=0:hd%=0

145 rem *** building level array - h64-004 ***
146 dim bl%(7)

150 rem *** building economics tables - h64-005 ***
160 dim bc%(7),bu%(7),bn$(7)
170 for bg=0 to 7:read bc%(bg),bu%(bg),bn$(bg):next bg

200 rem *** building economics data (200-290) - h64-005 ***
210 data 800,40,"irrigation"
220 data 600,20,"granary"
230 data 1000,30,"city walls"
240 data 700,25,"levees"
250 data 900,35,"aqueduct"
260 data 500,15,"temple"
270 data 750,30,"marketplace"
280 data 850,35,"tax office"

300 rem *** tunable constants (300-390) - h64-006 ***
310 tg%=1000:hy%=3:se=.5:ea%=20:wk%=10
320 br=.03:dr=.02:tx=.5:sr=.45

!- **************************************************************************
!- * Main Turn Loop (H64-010)
!- * OV% = game-over flag (0=playing, nonzero=victory or loss fired).
!- * Phase order per spec Sec.3: display -> advisor -> decisions -> resolution.
!- * Each phase is a stub GOSUB target until its own story fills it in.
!- **************************************************************************

500 rem *** main turn loop (500-590) - h64-010 ***
505 ov%=0
510 gosub 3000 : rem display status (stub - real in h64-011)
520 gosub 5000 : rem advisor report (stub - real in h64-070+)
530 gosub 7000 : rem player decisions (stub - real in h64-013/020-026)
540 gosub 1000 : rem end-year resolution (stub - real in h64-030+)
550 if ov%=0 then 510
560 print "game over (stub)"
570 end

1000 rem *** end-year resolution (1000-1990) - stub, real in h64-030+ ***
1010 yr%=yr%+1
1040 return

3000 rem *** display status (3000-3990) - stub, real in h64-011 ***
3030 return

5000 rem *** advisor report (5000-5990) - stub, real in h64-070+ ***
5010 return

7000 rem *** player decisions (7000-7990) - stub, real in h64-013/020-026 ***
7010 return
