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
const_177574726665576000 == 
{e1, e2}
----

\* MV CONSTANT definitions Person
const_177574726665577000 == 
{p1, p2}
----

\* CONSTANT definitions @modelParameterConstants:1FloorCount
const_177574726665578000 == 
3
----

=============================================================================
\* Modification History
\* Created Thu Apr 09 16:07:46 WEST 2026 by eamachado
