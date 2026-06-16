---------------------------- MODULE ElevatorCancel ----------------------------

(* Extends the elevator system with request cancellation.
   A waiting person can cancel before entering the elevator.
   Uses the original Elevator module via the E! prefix. *)

EXTENDS Integers

CONSTANTS Person, Elevator, FloorCount

VARIABLES PersonState, ActiveElevatorCalls, ElevatorState

E == INSTANCE Elevator

Vars == <<PersonState, ActiveElevatorCalls, ElevatorState>>

(* A person cancels their elevator request.
   Only possible if they are still waiting on a floor.
   If no one else is waiting for the same call, the call is removed. *)
CancelElevator(p) ==
    LET
      pState == PersonState[p]
      call == [floor |-> pState.location,
               direction |-> E!GetDirection[pState.location, pState.destination]]
      othersWaiting == E!PeopleWaiting[call.floor, call.direction] \ {p}
    IN
    /\ pState.waiting
    /\ pState.location \in E!Floor
    /\ PersonState' = [PersonState EXCEPT ![p] = [@ EXCEPT !.waiting = FALSE]]
    /\ ActiveElevatorCalls' =
        IF othersWaiting = {}
        THEN ActiveElevatorCalls \ {call}
        ELSE ActiveElevatorCalls
    /\ UNCHANGED ElevatorState

(* All original transitions plus the new cancellation action. *)
Next ==
    \/ E!Next
    \/ \E p \in Person : CancelElevator(p)

(* Same fairness as the original spec.
   Cancellation is voluntary, so no fairness is added for it. *)
Spec ==
    /\ E!Init
    /\ [][Next]_Vars
    /\ E!TemporalAssumptions

(* The original liveness property no longer holds as-is, because a person
   may cancel and never reach their destination. This weaker version
   allows either outcome: arrival or cancellation. *)
TemporalInvariantCancel ==
    /\ \A c \in E!ElevatorCall :
        /\ c \in ActiveElevatorCalls ~>
            (\E e \in Elevator : E!CanServiceCall[e, c]) \/ c \notin ActiveElevatorCalls
    /\ \A p \in Person :
        /\ PersonState[p].waiting ~>
            (PersonState[p].location = PersonState[p].destination
            \/ ~PersonState[p].waiting)

(* Type and safety invariants still hold after adding cancellation. *)
THEOREM Spec => [](E!TypeInvariant /\ E!SafetyInvariant)

=============================================================================