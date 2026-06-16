-------------------------- MODULE AbstractElevator --------------------------

(***************************************************************************)
(* This in an abstract specification of the original elevator spec         *)
(* It completly ignores elevator internals, focusing only on people and    *)
(* their progress towards their destitination. This model also groups some *)
(* concrete steps from the original spec (move, enter and exit elevator)   *)
(* into a single abstract spec (transport)*)
(***************************************************************************)

EXTENDS Integers

CONSTANTS Person,       \* The set of all people using the elevator system
          FloorCount    \* The number of floors serviced by the elevator system

VARIABLES PersonState
           
Vars == <<PersonState>>

Floor ==    \* The set of all floors
    1 .. FloorCount

TypeInvariant == PersonState \in [Person -> [location : Floor, destination : Floor, waiting : BOOLEAN]]

PickNewDestination(p) ==        \* Person decides they need to go to a different floor (similar to original spec)
    LET pState == PersonState[p] IN
    /\ ~pState.waiting
    /\ pState.location = pState.destination
    /\ \E f \in Floor :
        /\ f /= pState.location
        /\ PersonState' =
            [PersonState EXCEPT ![p] =
                [@ EXCEPT !.destination = f]]
                
RequestRide(p) ==               \* Person requests a ride (similar to CallElevator in original spec)
    LET pState == PersonState[p] IN
    /\ ~pState.waiting
    /\ pState.location /= pState.destination
    /\ PersonState' =
        [PersonState EXCEPT ![p] =
            [@ EXCEPT !.waiting = TRUE]]
            
Transport ==                    \* Move waiting people directly to destination and completing the ride (abstract step)
    /\ \E p \in Person : PersonState[p].waiting
    /\ PersonState' =
        [p \in Person |->
            IF PersonState[p].waiting
            THEN [PersonState[p] EXCEPT
                    !.location = @.destination,
                    !.waiting = FALSE]
            ELSE PersonState[p]]
            
Init == PersonState \in [Person -> [location : Floor, destination : Floor, waiting : {FALSE}]]

Next == \* The next-state relation
    \/ \E p \in Person : PickNewDestination(p)
    \/ \E p \in Person : RequestRide(p)
    \/ Transport
    
EventuallyArrive == \* Liveness property
    \A p \in Person :
        PersonState[p].waiting ~> PersonState[p].location = PersonState[p].destination

Spec ==
    /\ Init
    /\ [][Next]_Vars
    /\ WF_Vars(Transport)   \* If a person is continuously waiting, transport is enabled, so WF is ensured

THEOREM Spec => [](TypeInvariant) /\ EventuallyArrive

=============================================================================
\* Modification History
\* Last modified Sun Apr 12 15:06:47 WEST 2026 by lindo
\* Created Sun Apr 12 14:25:40 WEST 2026 by lindo
