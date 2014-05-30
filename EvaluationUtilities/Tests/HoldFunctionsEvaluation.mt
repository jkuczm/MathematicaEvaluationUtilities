(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`HoldFunctionsEvaluation`"];


(* Mock functions *)
ClearAll["mockFunc*"];

$mockFunc1Evaluations = {}
SetAttributes[mockFunc1, Orderless]
Options[mockFunc1] = {"mockFunc1Opt" -> "mockFunc1OptVal"}
mockFunc1[args___] := (
	AppendTo[$mockFunc1Evaluations, HoldComplete[args]];
	"mockFunc1 evaluated with: " <> ToString[HoldForm[{args}]]
)

$mockFunc2Evaluations = {}
mockFunc2[args___] := (
	AppendTo[$mockFunc2Evaluations, HoldComplete[args]];
	"mockFunc2 evaluated with: " <> ToString[HoldForm[{args}]]
)


(* ::Section:: *)
(*Tests*)


Block[
	{$mockFunc1Evaluations = {}, $mockFunc2Evaluations = {}}
	,
	TestMatch[
		HoldFunctionsEvaluation[
			{}
			,
			mockFunc1["arg1"]
		]
		,
		HoldPattern[HoldFunctionsEvaluation[{}, mockFunc1["arg1"]]]
		,
		TestID -> "hold zero functions: \
HoldFunctionsEvaluation evaluation: stays unevaluated"
	];
	Test[
		$mockFunc1Evaluations
		,
		{}
		,
		TestID -> "hold zero functions: \
mockFunc1 not really called"
	];
	Test[
		$mockFunc2Evaluations
		,
		{}
		,
		TestID -> "hold zero functions: \
mockFunc2 not really called"
	];
]


Block[
	{$mockFunc1Evaluations = {}, $mockFunc2Evaluations = {}}
	,
	Test[
		HoldFunctionsEvaluation[
			{mockFunc1}
			,
			mockFunc1["arg1"]
		]
		,
		HoldComplete[mockFunc1["arg1"]]
		,
		TestID -> "hold one function, call same one: \
HoldFunctionsEvaluation evaluation"
	];
	Test[
		$mockFunc1Evaluations
		,
		{}
		,
		TestID -> "hold one function, call same one: \
mockFunc1 not really called"
	];
	Test[
		$mockFunc2Evaluations
		,
		{}
		,
		TestID -> "hold one function, call same one: \
mockFunc2 not really called"
	];
]


Block[
	{$mockFunc1Evaluations = {}, $mockFunc2Evaluations = {}}
	,
	Test[
		HoldFunctionsEvaluation[
			{mockFunc1}
			,
			mockFunc2["arg1"]
		]
		,
		"mockFunc2 evaluated with: {arg1}"
		,
		TestID -> "hold one function, call different one: \
HoldFunctionsEvaluation evaluation"
	];
	Test[
		$mockFunc1Evaluations
		,
		{}
		,
		TestID -> "hold one function, call different one: \
mockFunc1 not really called"
	];
	Test[
		$mockFunc2Evaluations
		,
		{HoldComplete["arg1"]}
		,
		TestID -> "hold one function, call different one: \
mockFunc2 called once"
	];
]


Block[
	{$mockFunc1Evaluations = {}, $mockFunc2Evaluations = {}}
	,
	Test[
		HoldFunctionsEvaluation[
			{mockFunc1, mockFunc2}
			,
			{
				mockFunc1["arg1"],
				mockFunc2["arg2"]
			}
			,
			"LogFunctionCalls" -> {}
		]
		,
		{HoldComplete[mockFunc1["arg1"]], HoldComplete[mockFunc2["arg2"]]}
		,
		TestID -> "hold two functions, call both, no logging: \
HoldFunctionsEvaluation evaluation"
	];
	Test[
		$mockFunc1Evaluations
		,
		{}
		,
		TestID -> "hold two functions, call both, no logging: \
mockFunc1 not really called"
	];
	Test[
		$mockFunc2Evaluations
		,
		{}
		,
		TestID -> "hold two functions, call both, no logging: \
mockFunc2 not really called"
	];
]


Block[
	{$mockFunc1Evaluations = {}, $mockFunc2Evaluations = {}}
	,
	Test[
		HoldFunctionsEvaluation[
			{mockFunc1, mockFunc2}
			,
			{
				mockFunc1["arg1"],
				mockFunc2["arg2"]
			}
			,
			"LogFunctionCalls" -> {mockFunc1}
		]
		,
		{HoldComplete[mockFunc1["arg1"]], HoldComplete[mockFunc2["arg2"]]}
		,
		TestID -> "hold two functions, call both, log mockFunc1 calls: \
HoldFunctionsEvaluation evaluation"
	];
	Test[
		$mockFunc1Evaluations
		,
		{}
		,
		TestID -> "hold two functions, call both, log mockFunc1 calls: \
mockFunc1 not really called"
	];
	Test[
		$mockFunc2Evaluations
		,
		{}
		,
		TestID -> "hold two functions, call both, log mockFunc1 calls: \
mockFunc2 not really called"
	];
]


Block[
	{$mockFunc1Evaluations = {}, $mockFunc2Evaluations = {}}
	,
	Test[
		HoldFunctionsEvaluation[
			{mockFunc1, mockFunc2}
			,
			{
				mockFunc1["arg1"],
				mockFunc2["arg2"]
			}
			,
			"LogFunctionCalls" -> All
		]
		,
		{HoldComplete[mockFunc1["arg1"]], HoldComplete[mockFunc2["arg2"]]}
		,
		TestID -> "hold two functions, call both, log all calls: \
HoldFunctionsEvaluation evaluation"
	];
	Test[
		$mockFunc1Evaluations
		,
		{}
		,
		TestID -> "hold two functions, call both, log all calls: \
mockFunc1 not really called"
	];
	Test[
		$mockFunc2Evaluations
		,
		{}
		,
		TestID -> "hold two functions, call both, log all calls: \
mockFunc2 not really called"
	];
]


Test[
	HoldFunctionsEvaluation[
		{mockFunc1}
		,
		Options[mockFunc1]
	]
	,
	{"mockFunc1Opt" -> "mockFunc1OptVal"}
	,
	TestID -> "hold one function, return its options: \
HoldFunctionsEvaluation evaluation"
];


Test[
	HoldFunctionsEvaluation[
		{mockFunc1}
		,
		Attributes[mockFunc1]
	]
	,
	{Orderless}
	,
	TestID -> "hold one function, return its attributes: \
HoldFunctionsEvaluation evaluation"
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
