(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`TraceLog`"];


(* ::Section:: *)
(*Tests*)


TestMatch[
	TraceLog[2 + 2]
	,
	HoldPattern[TraceLog[2 + 2]]
	,
	TestID -> "one argument: \
TraceLog stays unevaluated"
];


Module[
	{$Log1, $Log2}
	,
	Test[
		TraceLog[
			(2 + 2)*(3 + 5) + 4*1
			,
			{_Plus -> $Log1, _Times -> $Log2}
		]
		,
		36
		,
		TestID -> "two logs for two functions: \
TraceLog evaluation"
	];
	Test[
		$Log1
		,
		{
			HoldForm[(2 + 2)*(3 + 5) + 4*1], HoldForm[2 + 2],
			HoldForm[3 + 5], HoldForm[32 + 4]
		}
		,
		TestID -> "two external logs for two functions: \
first log"
	];
	Test[
		$Log2
		,
		{HoldForm[(2 + 2)*(3 + 5)], HoldForm[4*8], HoldForm[4*1]}
		,
		TestID -> "two external logs for two functions: \
second log"
	];
];


Module[
	{$Log}
	,
	Test[
		TraceLog[
			(2 + 2)*(3 + 5) + 4*1
			,
			{_Plus | _Times -> $Log}
		]
		,
		36
		,
		TestID -> "one log for two functions: \
TraceLog evaluation"
	];
	Test[
		$Log
		,
		{
			HoldForm[(2 + 2)*(3 + 5) + 4*1], HoldForm[(2 + 2)*(3 + 5)],
			HoldForm[2 + 2], HoldForm[3 + 5], HoldForm[4*8], HoldForm[4*1],
			HoldForm[32 + 4]
		}
		,
		TestID -> "one log for two functions: \
first log"
	];
];


Module[
	{$Log1, $Log2}
	,
	Test[
		TraceLog[
			(2 + 2)*(3 + 5) + 4*1
			,
			{Plus[2, ___] -> $Log1, _Plus -> $Log2}
		]
		,
		36
		,
		TestID -> "two logs one for function with specific argument: \
TraceLog evaluation"
	];
	Test[
		$Log1
		,
		{HoldForm[2 + 2]}
		,
		TestID -> "two logs one for function with specific argument: \
first log"
	];
	Test[
		$Log2
		,
		{
			HoldForm[(2 + 2)*(3 + 5) + 4*1], HoldForm[2 + 2], HoldForm[3 + 5],
			HoldForm[32 + 4]
		}
		,
		TestID -> "two logs one for function with specific argument: \
second log"
	];
];


Module[
	{$Log}
	,
	Test[
		TraceLog[
			2 + 2
			,
			_Plus -> $Log
		]
		,
		4
		,
		TestID -> "one log not in list: \
TraceLog evaluation"
	];
	Test[
		$Log
		,
		{HoldForm[2 + 2]}
		,
		TestID -> "one log not in list: \
first log"
	];
];


Module[
	{$Log = 5}
	,
	Test[
		TraceLog[
			2 + 2
			,
			{_Plus -> $Log}
		]
		,
		4
		,
		TestID -> "one log varable with already assigned value: \
TraceLog evaluation"
	];
	Test[
		$Log
		,
		{HoldForm[2 + 2]}
		,
		TestID -> "one log varable with already assigned value: \
first log"
	];
];


Module[
	{$Log, mockFunc, $mockFuncSideEffects = {}}
	,
	
	mockFunc[x_] := (
		AppendTo[$mockFuncSideEffects, x];
		"mockFunc evaluated with: " <> ToString[x]
	);
	
	Test[
		TraceLog[
			mockFunc[2 + 2]
			,
			{_mockFunc -> $Log}
		]
		,
		"mockFunc evaluated with: 4"
		,
		TestID -> "one log for mock function: \
TraceLog evaluation: \
mock function returned value not changed"
	];
	Test[
		$mockFuncSideEffects
		,
		{4}
		,
		TestID -> "one log for mock function: \
mock function side effects not changed"
	];
	Test[
		$Log
		,
		{HoldForm[mockFunc[2 + 2]], HoldForm[mockFunc[4]]}
		,
		TestID -> "one log for mock function: \
log"
	];
];


Module[
	{$Log}
	,
	Test[
		TraceLog[
			(2 + 2)*(3 + 5) + 4*1
			,
			{_Plus | _Times -> $Log}
			,
			TraceDepth -> 1
		]
		,
		36
		,
		TestID -> "options passing: \
TraceLog evaluation"
	];
	Test[
		$Log
		,
		{HoldForm[(2 + 2)*(3 + 5) + 4*1], HoldForm[32 + 4]}
		,
		TestID -> "options passing: \
first log"
	];
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
