----------------MODULE transactioncommit-------------------------------------

CONSTANT RM
VARIABLE rmState

TCTypeOk == rmState \in [RM -> {"working", "prepared", "commited", "aborted"}]

TCInit == rmState = [r \in RM |-> "working"]

Terminate == /\ \A r \in RM : rmState[r] \in {"aborted", "commited"}
             /\ rmState' = rmState

(************************************************************************)
(* There are two phased, perpare -> going from working to prepared, and *)
(* decide -> going from prepared to commited or abored                  *)
(************************************************************************)


canCommit == \A r \in RM : rmState[r] \in {"prepared" , "commited"}
canAbort == \A r \in RM : rmState[r] /= "commited"

Prepare(r) == /\ rmState[r] = "working"
              /\ rmState' = [rmState EXCEPT ![r] = "prepared"]

Decide(r) == \/ /\ rmState[r] = "prepared"
                /\ canCommit
                /\ rmState' = [rmState EXCEPT ![r] = "commited"]
             \/ /\ rmState[r] = "prepared"
                /\ canAbort
                /\ rmState' = [rmState EXCEPT ![r] = "aborted"]

TCNext == \E r \in RM : Prepare(r) \/ Decide(r) \/ Terminate

TCConsistent == \A r1, r2 \in RM : ~ /\ rmState[r1] = "aborted"
                                     /\ rmState[r2] = "commited"

Spec == TCInit /\ [][TCNext]_rmState

===============================================================================
