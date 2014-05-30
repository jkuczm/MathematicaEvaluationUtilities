(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`EvaluateOneStep`"];


a = b;
b = c;


(* ::Section:: *)
(*Tests*)


Test[
	EvaluateOneStep[a]
	,
	HoldForm[b]
	,
	TestID -> "basic"
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
