100 print "{clear}{white}welcome": print"try your hand at governing ancient sumeria"
110 print "successfully for a 10-yr term of office.":print


!- **************************************************************************
!- * Variables
!- *           z        The Year counter
!- *           d        # of people that starved in a year
!-             i        # of people came to the city in a year

!- **************************************************************************

120 d1=0:p1=0
130 z=0:p=95:s=2800:h=3000:e=h-s
140 y=3:a=h/y:i=5:q=1
150 d=0
160 print:print
162 print "hamurabi:  i beg to report to you,":z=z+1
170 print "in year"z","d"people starved,"i"came to the city."
180 p=p+i

200 if q>0 then 230
210 p=int(p/2)
220 print "a horrible plague struck!  half the people died."
230 print "population is now"p
240 print "the city now owns"a"acres."
250 print "you harvested"y"bushels per acre."
260 print "rats ate"e"bushels."
270 print "you now have"s"bushels in store.":print
280 if z=11 then 1040
290 c=int(10*rnd(1)):y=c+17
300 print "land is trading at"y"bushels per acre."
310 print "how many acres do you wish to buy";
320 input q:if q<0 then 1010
330 if y*q<=s then 360
340 gosub 940
350 goto 310
360 if q=0 then 390
370 a=a+q:s=s-y*q:c=0
380 goto 450
390 print "how many acres do you wish to sell";
400 input q:if q<0 then 1010
410 if q<a then 440
420 gosub 970
430 goto 390
440 a=a-q:s=s+y*q:c=0
450 print
460 print "how many bushels do you wish to feed your people";
470 input q
480 if q<0 then 1010
490 rem *** trying to use more grain than in the silos?
500 if q<=s then 530
510 gosub 940
520 goto 460
530 s=s-q:c=1:print
540 print "how many acres do you wish to plant with seed";
550 input d:if d=0 then 700
560 if d<0 then 1010
570 rem *** trying to plant more acres than you own?
580 if d<=a then 620
590 gosub 970
600 goto 540
610 rem *** enough grain for seed?
620 if int(d/2)<s then 660
630 gosub 940
640 goto 540
650 rem *** enough people to tend the crops?
660 if d<10*p then 690
670 print "but you have only"p"people to tend the fields. now then,"
680 goto 540
690 s=s-int(d/2)
700 gosub 990
710 rem *** a bountyfull harvest!!
720 y=c:h=d*y:e=0
730 gosub 990
740 if int(c/2)<>c/2 then 770
750 rem *** the rats are running wild!!
760 e=int(s/c)
770 s=s-e+h
780 gosub 990
790 rem *** let's have some babies
800 i=int(c*(20*a+s)/p/100+1)
810 rem *** how many people had full tummies?
820 c=int(q/20)
830 rem *** horrors, a 15% chance of plague
840 q=int(10*(2*rnd(1)-.3))
850 if p<c then 150
860 rem *** starve enough for impeachment?
870 d=p-c:if d>.45*p then 900
880 p1=((z-1)*p1+d*100/p)/z
890 p=c:d1=d1+d:goto 160
900 print:print "you starved"d"people in one year!!!"
910 print "due to this extreme mismanagement you have not only"
920 print "been impeached and thrown out of office but you have"
930 print "also been declared 'national fink' !!":goto 1250
940 print "hamurabi:  think again. you have only"
950 print s"bushels of grain.  now then,"
960 return
970 print "hamurabi:  think again. you own only"a"acres.  now then,"
980 return
990 c=int(rnd(1)*5)+1
1000 return
1010 print:print "hamurabi:  i cannot do what you wish."
1020 print "get yourself another steward!!!!!"
1030 goto 1250
1040 print "in your 10-year term of office,"p1"percent of the"
1050 print "population starved per year on average, i.e., a total of"
1060 print d1"people died!!":l=a/p
1070 print "you started with 10 acres per person and ended with"
1080 print l"acres per person.":print
1090 if p1>33 then 910
1100 if l<7 then 910
1110 if p1>10 then 1170
1120 if l<9 then 1170
1130 if p1>3 then 1200
1140 if l<10 then 1200
1150 print "a fantastic performance!!!  charlemange, disraeli, and"
1160 print "jefferson combined could not have done better!":goto 1250
1170 print "your heavy-handed performance smacks of nero and ivan iv."
1180 print "the people (remaining) find you an unpleasant ruler, and,"
1190 print "frankly, hate your guts!":goto 1250
1200 print "your performance could have been somewhat better, but"
1210 print "really wasn't too bad at all. ";
1220 print int(p*.8*rnd(1));"people would"
1230 print "dearly like to see you assassinated but we all have our"
1240 print "trivial problems."
1250 print:for n=1 to 10:print chr$(7);:next n
1260 print "so long for now.":print
1270 end