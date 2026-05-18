----- MODULE die_hard ----------

EXTENDS Integers
VARIABLES small, big

vars == <<small, big>>

TypeOk == /\ small \in 0..3
          /\ big \in 0..5

Goal == big /= 4

Init == /\ small = 0
        /\ big = 0

FillSmall == /\ small' = 3
             /\ big' = big

FillBig == /\ small' = small
           /\ big' = 5

EmptySmall == /\ small' = 0
              /\ big' = big

EmptyBig == /\ small' = small
            /\ big' = 0

SmallToBig == IF big + small =< 5
                THEN /\ big' = big + small 
                     /\ small' = 0
                ELSE /\ big' = 5
                     /\ small' = small - (5 - big)

BigToSmall == IF big + small =< 3
                THEN /\ big' = 0
                     /\ small' = big + small
                ELSE /\ small' = 3
                     /\ big' = big - (3 - small)

Next == \/ FillBig
        \/ FillSmall
        \/ EmptySmall
        \/ EmptyBig
        \/ SmallToBig
        \/ BigToSmall

Spec == Init /\ [][Next]_<<vars>>
==============================
