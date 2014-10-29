(* ::Package:: *)

BeginPackage["EvaluationUtilities`"]


(* ::Section:: *)
(*Usage messages*)


TraceLog::usage =
"\
TraceLog[expr, patt -> log] \
evaluates expr and logs, in log, each subexpression that matches patt. Result \
of expr evaluation is returned.\

TraceLog[expr, {patt1 -> log1, patt2 -> log2, ...}] \
logs subexpressions matching patti in logi."


HoldFunctionsEvaluation::usage =
"\
HoldFunctionsEvaluation[{func1, func2, ...}, body] \
evaluates body with every occurence of funci[args] replaced by \
HoldComplete[funci[args]]."


EvaluateOneStep::usage =
"\
EvaluateOneStep[expr] \
returns expr after \"one step\" of evaluation."


(* ::Section:: *)
(*Implementation*)


(*
	Unprotect all symbols in this context
	(all public symbols provided by this package)
*)
Unprotect["`*"]


Begin["`Private`"]


(* ::Subsection:: *)
(*Imports*)


Needs["OptionsUtilities`"] (* DelegateOptions, CopyFeatures *)


(* ::Subsection:: *)
(*TraceLog*)


Protect[TraceLogInternalTag];


CopyFeatures[TraceScan, TraceLog]


TraceLog[expr_, pattsToLogs:{__Rule}, opts:OptionsPattern[]] :=
	Module[
		{
			patts = First /@ pattsToLogs,
			result, log
		}
		,
		With[
			{
				pattsAlter = Alternatives @@ patts,
				delegatedOpts = DelegateOptions[opts, TraceLog, TraceScan]
			}
			,
			{result, log} =
				Reap[
					TraceScan[
						Sow[#, TraceLogInternalTag[#]]&,
						expr,
						pattsAlter,
						delegatedOpts
					]
					,
					TraceLogInternalTag /@ HoldForm /@ patts
				];
		];
		
		MapThread[
			Set
			,
			{
				(* Make sure variable is passed to Set in unevaluated form. *)
				Map[Unevaluated, Hold[pattsToLogs], {3}][[1, 1;;-1, 2]],
				Flatten /@ log
			}
		];
		
		result
	]

TraceLog[expr_, rule_Rule, opts:OptionsPattern[]] :=
	TraceLog[expr, {rule}, opts]


(* ::Subsection:: *)
(*HoldFunctionsEvaluation*)


SetAttributes[HoldFunctionsEvaluation, HoldRest]


HoldFunctionsEvaluation[funcs:{__Symbol}, body_, OptionsPattern[]] :=
	With[
		{
			options = Options /@ funcs,
			attributes = Attributes /@ funcs
		}
		,		
		Block[
			funcs
			,
			(funcCall:#[___] := HoldComplete[funcCall])& /@ funcs;
			
			MapThread[
				(
					Options[#1] = #2;
					SetAttributes[#1, #3];
				)&
				,
				{funcs, options, attributes}
			];
			
			body
		]
	];


(* ::Subsection:: *)
(*EvaluateOneStep*)


SetAttributes[EvaluateOneStep, HoldAll]


EvaluateOneStep[expr_] :=
	Module[
		{P}
		,
		P = (P = Return[#, TraceScan] &) &;
		TraceScan[P, expr, TraceDepth -> 1]
	]


End[]


(* ::Subsection:: *)
(*Public symbols protection*)


(*
	Protect all symbols in this context
	(all public symbols provided by this package)
*)
Protect["`*"]


EndPackage[]

