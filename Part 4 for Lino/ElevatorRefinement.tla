---------------------------- MODULE ElevatorRefinement ----------------------------

EXTENDS Integers

CONSTANTS Person, Elevator, FloorCount

VARIABLES PersonState, ActiveElevatorCalls, ElevatorState

E == INSTANCE Elevator WITH
    Person <- Person,
    Elevator <- Elevator,
    FloorCount <- FloorCount,
    PersonState <- PersonState,
    ActiveElevatorCalls <- ActiveElevatorCalls,
    ElevatorState <- ElevatorState

AbsLocation(p) ==
    IF PersonState[p].location \in E!Floor
    THEN PersonState[p].location
    ELSE ElevatorState[PersonState[p].location].floor

AbsPersonState ==
    [p \in Person |->
        [ location    |-> AbsLocation(p),
          destination |-> PersonState[p].destination,
          waiting     |-> PersonState[p].waiting]]

AbsElevator == INSTANCE AbstractElevator WITH
    Person <- Person,
    FloorCount <- FloorCount,
    PersonState <- AbsPersonState

THEOREM E!Spec => AbsElevator!SpecNoFair
THEOREM E!Spec => AbsElevator!EventuallyArrive
====================================================================