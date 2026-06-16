---- MODULE MC ----
EXTENDS Elevator, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
e1, e2
----

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
p1, p2
----

\* MV CONSTANT definitions Elevator
const_177592457774322000 == 
{e1, e2}
----

\* MV CONSTANT definitions Person
const_177592457774323000 == 
{p1, p2}
----

\* CONSTANT definitions @modelParameterConstants:1FloorCount
const_177592457774324000 == 
3
----

=============================================================================
\* Modification History
\* Created Sat Apr 11 17:22:57 WEST 2026 by eamachado
