(* ::Package:: *)

Module[
	{$PIImportResult}
	,
	
	Quiet[
		$PIImportResult = Needs["ProjectInstaller`"],
		{Get::noopen, Needs::nocont}
	];
	
	If[$PIImportResult === $Failed,
		Print["ProjectInstaller not found, installing it:"];
		Print @ Import[
			"https://raw.github.com/lshifr/ProjectInstaller/master/BootstrapInstall.m"
		];
		$PIImportResult = Needs["ProjectInstaller`"];
	];

	If[$PIImportResult === $Failed,
		Print[
			"Unable to load ProjectInstaller.\n",
			"Please ",
			Hyperlink[
				"install EvaluationUtilities package manually",
				"https://github.com/jkuczm/MathematicaEvaluationUtilities#manual-installation"
			],
			".\n",
			"We would be grateful for ",
			Hyperlink[
				"reporting this issue",
				"https://github.com/jkuczm/MathematicaEvaluationUtilities/issues"
			],
			"."
		];
	(* else *),
		Print["Installing dependencies:"];
		Get[
			"https://raw.githubusercontent.com/jkuczm/MathematicaOptionsUtilities/master/BootstrapInstall.m"
		];
		
		Print["Installing EvaluationUtilities:"];
		Print @ ProjectInstaller`ProjectInstall @ URL[
			"https://github.com/jkuczm/MathematicaEvaluationUtilities/releases/download/v0.1.0/EvaluationUtilities.zip"
		];
	];
]
