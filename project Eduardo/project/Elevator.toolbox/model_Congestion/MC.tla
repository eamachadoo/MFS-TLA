---- MODULE MC ----
EXTENDS Elevator, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
e1
----

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
p1, p2, p3, p4
----

\* MV CONSTANT definitions Elevator
const_177574760338897000 == 
{e1}
----

\* MV CONSTANT definitions Person
const_177574760338898000 == 
{p1, p2, p3, p4}
----

\* CONSTANT definitions @modelParameterConstants:1FloorCount
const_177574760338999000 == 
3
----

=============================================================================
\* Modification History
\* Created Thu Apr 09 16:13:23 WEST 2026 by eamachado
