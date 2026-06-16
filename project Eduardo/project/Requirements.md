# Project 1 Brief: Elevator System Specification and Refinement
This is the brief for the first project of the MFS course 2025/26. In this project, you will work with an existing TLA+ specification of a multi-elevator system, explore its properties, and evolve it through abstraction and extension. The project is designed to help you practice reading and understanding TLA+ specifications, using TLC for validation, reasoning about fairness and liveness, and designing refinements and extensions. **The deadline for submission is the 17th of April, 2026.** The project should be done in **groups of 3 students**t status.
Please read the full brief carefully and follow the instructions for each part of the project.
See [Deliverables](#deliverables) for details on what to submit.

## Table of Contents
- [Project 1 Brief: Elevator System Specification and Refinement](#project-1-brief-elevator-system-specification-and-refinement)
  - [Table of Contents](#table-of-contents)
  - [Context](#context)
  - [Learning goals](#learning-goals)
  - [What is already solved in `Elevator.tla`](#what-is-already-solved-in-elevatortla)
  - [Project tasks](#project-tasks)
    - [Part 1: Baseline validation and model understanding](#part-1-baseline-validation-and-model-understanding)
    - [Part 2: Fairness and liveness sensitivity study](#part-2-fairness-and-liveness-sensitivity-study)
    - [Part 3: New Properties](#part-3-new-properties)
    - [Part 4: Let's Abstract!](#part-4-lets-abstract)
      - [4.1. Abstract specification](#41-abstract-specification)
      - [4.2. Refinement mapping](#42-refinement-mapping)
    - [Part 5: Add Request Cancellation to the Elevator Specification](#part-5-add-request-cancellation-to-the-elevator-specification)
      - [Requirements](#requirements)
      - [Tasks](#tasks)
  - [Deliverables](#deliverables)
  - [Assessment criteria](#assessment-criteria)
  - [Notes](#notes)

## Context

You are given an existing TLA+ specification in [Elevator.tla](Elevator.tla). This file already models a non-trivial multi-elevator system with:

- people requesting rides (`PersonState`),
- active hall calls (`ActiveElevatorCalls`),
- per-elevator state (`ElevatorState`),
- dispatching logic (`DispatchElevator`),
- safety and temporal properties,
- fairness assumptions and a top-level theorem.

This means you are **not** starting from zero. Your goal is to treat this model as a baseline, explore it, and evolve it.

The original specification is taken from here: [https://github.com/tlaplus/Examples/tree/master/specifications/MultiCarElevator](https://github.com/tlaplus/Examples/tree/master/specifications/MultiCarElevator). 


## Learning goals

By the end of the project, you should be able to:

1. Be more proficient in reading and understanding TLA+ specifications.
2. Use TLC to validate safety and liveness properties on an abstract model.
3. Reason about how fairness choices (WF vs SF) impact progress/starvation.
4. Define and justify a refinement/implementation step over an existing spec.
5. Design and analyze an extension to an existing spec.

---

## What is already solved in `Elevator.tla`

The given file already contains:

- Core state space and transition system.
- Type and safety invariants.
- Temporal expectations are already encoded (`TemporalInvariant`).
- Fairness assumptions are already listed (`TemporalAssumptions`).
- A theorem already states `Spec => [](TypeInvariant /\ SafetyInvariant /\ TemporalInvariant)`.

Your work should build from this baseline rather than rewrite it.

---

## Project tasks

### Part 1: Baseline validation and model understanding

Starting from [Elevator.tla](Elevator.tla):

1. Create one or more TLC models (small finite instances) and run checks for:
   - `TypeInvariant`
   - `SafetyInvariant`
   - `TemporalInvariant`

Make sure that you read and understand the definitions of these invariants and the expected results.

1. Document which properties hold directly and which are expensive to check. The smallest instance that you should consider is a model with two people `p1`and `p2` (set of model values), one elevator `e1` (set of model values), and three floors. Document all configurations you used and the results you obtained. Check the impact of the different invariants on runtime and explain the reasons for the differences.

2. Explain the operational role of each key action:
   - `PickNewDestination`, `CallElevator`, `OpenElevatorDoors`,  `EnterElevator`, `ExitElevator`, `CloseElevatorDoors`, `MoveElevator`, `StopElevator`, and `DispatchElevator`.

---

### Part 2: Fairness and liveness sensitivity study

Use the same model and perform controlled fairness experiments.

1. Remove the strong fairness from `DispatchElevator`
2. Check whether liveness properties still hold. If not, include a TLC counterexample summary and explain why there are properties that fail.

---

### Part 3: New Properties

Assuming that your group has $N$ elements, write $N$ new interesting properties that you expect to hold in the model. Check whether this property holds with the current fairness assumptions. If it does not hold, explain why and what fairness assumptions would be needed to make it hold.

---

### Part 4: Let's Abstract!
The elevator specification provided contains a lot of details about the internal workings of the system. For example, it models the state of each elevator, the active calls, and the dispatching logic. However, from the perspective of passengers, many of these details are not relevant. The essential behavior from a passenger's perspective is that they want to get from their current location to their destination, and they want to be assured that if they request a ride, they will eventually reach their destination.

Develop a **simplified abstract model** that captures its essential behavior from the perspective of passengers.

#### 4.1. Abstract specification
1. **Design an abstract specification** of the elevator system that:
   - Ignores elevator internals (e.g., doors, movement, dispatching)
   - Focuses only on **people and their progress toward destinations**
   - Models the system in terms of:
     - A person’s `location`
     - A person’s `destination`
     - Whether the person is `waiting`

2. **Define the abstract behavior**
   - Include actions that capture:
     - Choosing a new destination
     - Requesting a ride
     - Being transported toward the destination
     - Completing the ride
   - Your abstraction may group multiple concrete steps into a single abstract step. Also note that the concrete model allows for multiple people to be transported simultaneously! The abstract model can represent this as a single action that updates the state of all waiting people.

3. **Specify a liveness property**
   - Formalize the requirement that:

     > If a person is waiting, they will eventually reach their destination

   - Express this property in TLA+ using temporal operators (e.g., `~>`)

4. **Ensure the abstract specification satisfies the property**
   - Add appropriate **fairness assumptions** if needed
   - Use TLC to check that your specification satisfies the liveness condition

#### 4.2. Refinement mapping

5. **Define a refinement mapping**
   - Map the concrete state (`Elevator.tla`) to your abstract state
   - In particular, define an abstraction for `PersonState`
   - Hint:
     - When a person is inside an elevator, you must decide how to represent their location abstractly

6. **Instantiate your abstract specification inside the concrete one**
   - Use `INSTANCE` with appropriate substitutions

7. **Check refinement using TLC**
   - Verify that the concrete system refines the abstract one. Write down the THEOREM statements and check them with TLC.


### Part 5: Add Request Cancellation to the Elevator Specification
Extend the elevator system with a new feature: a person who is waiting for an elevator may **cancel their request** before entering the elevator.

#### Requirements

Add a new action `CancelElevator(p)` such that:

- it is enabled only when person `p` is currently waiting on a floor;
- it sets `p`'s `waiting` field to `FALSE`;
- if `p` was the **last** person waiting for that floor/direction, the corresponding call is removed from `ActiveElevatorCalls`;
- otherwise, the call remains active.

#### Tasks

1. Define a new module that **reuses** the original `Elevator` specification rather than editing it directly. A clean way to do this is to create a new module that instantiates the original one and adds the new action.
2. Add the new `CancelElevator(p)` action.
3. Define a new `Next` and `Spec`.
4. Check with TLC that:
   - the type invariant still holds;
   - the safety invariant still holds.
5. Explain briefly why the original temporal invariant is no longer appropriate, and replace it with a new one that allows either:
   - the person eventually reaches the destination, or
   - the person eventually stops waiting.

---

## Deliverables

Submit a ZIP with:

1. Your TLA+ specs:
   - original baseline with new properties and refinements identified: `Elevator.tla`
   - abstract specification: `ElevatorAbstract.tla`
   - specification with request cancellation: `ElevatorCancel.tla`
2. TLC model configs used for each check.
3. A short report discussing your work on each part, including:
   - baseline understanding,
   - fairness experiments and outcomes,
   - new properties and their status,
   - abstract specification and refinement mapping,
   - request cancellation design and impact on properties.
  Make the report a companion to the specifications, not a replacement. Focus on explaining the design choices and the results of your checks. The report is an opportunity to demonstrate your understanding and reasoning, so be clear and concise.

**Deadline for submission: 17th of April, 2026.**

---

## Assessment criteria

| Criterion | Weight |
|---|---:|
| Baseline understanding and validation | 20% |
| Fairness sensitivity analysis | 20% |
| New properties definition and checking | 20% |
| Abstract specification and refinement | 20% |
| Request cancellation design and analysis | 15% |
| Clarity and quality of the report | 5% |

**Note:** You should comment your specifications to make it easier for the reader to understand your design choices and the properties you define.

---

## Notes

- Treat [Elevator.tla](Elevator.tla) as trusted starter code, but verify assumptions with TLC.
- Keep model sizes small first; scale only after basic checks pass.
- If liveness checks are expensive, justify your configuration choices and scope.
- It's acceptable to use small instances, as long as they are sufficient to validate the properties and illustrate the concepts.
- Precision matters more than adding many features.