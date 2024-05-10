{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, pkgs
, llm-claude
, pytest
, pytest-recording
}:

let
  anthropic = pkgs.python311Packages.anthropic;

  llm-claude-3 = buildPythonPackage
    rec {
      pname = "llm-claude-3";
      version = "0.3";
      pyproject = true;

      src = fetchFromGitHub {
        owner = "simonw";
        repo = "llm-claude-3";
        rev = version;
        hash = "sha256-MqcMpIhhMhWysq5aYEoKq/+gILZMnj/6uz+m73Bvc2E=";
      };

      nativeBuildInputs = [
        setuptools
        wheel
      ];

      propagatedBuildInputs = [
        anthropic
        llm-claude
      ];

      passthru.optional-dependencies = {
        test = [
          pytest
          pytest-recording
        ];
      };

      dontCheckRuntimeDeps = true;

      meta = with lib; {
        description = "LLM plugin for interacting with the Claude 3 family of models";
        homepage = "https://github.com/simonw/llm-claude-3";
        license = licenses.asl20;
        maintainers = with maintainers; [ jrmeland ];
      };
    };

in
llm-claude-3
