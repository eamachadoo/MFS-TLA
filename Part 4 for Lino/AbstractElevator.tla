-------------------------- MODULE AbstractElevator --------------------------

(***************************************************************************)
(* Abstract passenger-view specification.                                  *)
(* Elevator internals are hidden; only passenger progress is modeled.      *)
(***************************************************************************)

EXTENDS Integers

CONSTANTS Person,       \* The set of all people using the elevator system
          FloorCount    \* The number of floors serviced by the elevator system

VARIABLES PersonState

Vars == <<PersonState>>

Floor ==
    1 .. FloorCount

TypeInvariant ==
    PersonState \in [Person -> [location : Floor, destination : Floor, waiting : BOOLEAN]]

PickNewDestination(p) ==
    LET pState == PersonState[p] IN
    /\ ~pState.waiting
    /\ pState.location \in Floor
    /\ \E f \in Floor :
        /\ f /= pState.location
        /\ PersonState' = [PersonState EXCEPT ![p] = [@ EXCEPT !.destination = f]]

RequestRide(p) ==
    LET pState == PersonState[p] IN
    /\ ~pState.waiting
    /\ pState.location /= pState.destination
    /\ PersonState' = [PersonState EXCEPT ![p] = [@ EXCEPT !.waiting = TRUE]]

ProgressRide ==
    /\ \E moving \in SUBSET Person :
        /\ moving /= {}
        /\ \A p \in moving :
            /\ PersonState[p].waiting
            /\ PersonState[p].location /= PersonState[p].destination
        /\ \E newLoc \in [moving -> Floor] :
            /\ PersonState' = [p \in Person |->
                IF p \in moving
                THEN [PersonState[p] EXCEPT !.location = newLoc[p]]
                ELSE PersonState[p]]

CompleteRide ==
    /\ \E completed \in SUBSET Person :
        /\ completed /= {}
        /\ \A p \in completed : PersonState[p].waiting
        /\ PersonState' = [p \in Person |->
            IF p \in completed
            THEN [PersonState[p] EXCEPT !.location = PersonState[p].destination, !.waiting = FALSE]
            ELSE PersonState[p]]

Init ==
    /\ PersonState \in [Person -> [location : Floor, destination : Floor, waiting : {FALSE}]]

Next ==
    \/ \E p \in Person : PickNewDestination(p)
    \/ \E p \in Person : RequestRide(p)
    \/ ProgressRide
    \/ CompleteRide

TemporalAssumptions ==
    /\ \A p \in Person : WF_Vars(RequestRide(p))
    /\ SF_Vars(ProgressRide)
    /\ SF_Vars(CompleteRide)

SpecNoFair ==
    /\ Init
    /\ [][Next]_Vars

Spec ==
    /\ SpecNoFair
    /\ TemporalAssumptions

EventuallyArrive ==
    \A p \in Person :
        PersonState[p].waiting ~> PersonState[p].location = PersonState[p].destination

THEOREM Spec => []EventuallyArrive
=============================================================================
\* Modification History
\* Last modified Sun Apr 19 19:44:21 BST 2026 by gioma
\* Last modified Sun Apr 12 15:06:47 WEST 2026 by lindo
\* Created Sun Apr 12 14:25:40 WEST 2026 by lindo
