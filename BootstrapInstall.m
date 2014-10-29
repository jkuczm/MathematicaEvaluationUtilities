(* ::Package:: *)

Get["https://raw.githubusercontent.com/jkuczm/MathematicaBootstrapInstaller/v0.1.1/BootstrapInstaller.m"]


BootstrapInstall[
	"EvaluationUtilities",
	"https://github.com/jkuczm/MathematicaEvaluationUtilities/releases/download/v0.1.0/EvaluationUtilities.zip"
	,
	{{
		"OptionsUtilities",
		"https://github.com/jkuczm/MathematicaOptionsUtilities/releases/download/v0.1.0/OptionsUtilities.zip"
	}}
	,
	"AdditionalFailureMessage" ->
		Sequence[
			"You can ",
			Hyperlink[
				"install EvaluationUtilities package manually",
				"https://github.com/jkuczm/MathematicaEvaluationUtilities#manual-installation"
			],
			"."
		]
]
