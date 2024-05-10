{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, anthropic
, llm
, llm-claude
, pytest
, pytest-recording
}:

buildPythonPackage rec {
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
    llm
    llm-claude
  ];

  passthru.optional-dependencies = {
    test = [
      pytest
      pytest-recording
    ];
  };

  pythonImportsCheck = [ "llm_claude_3" ];

  meta = with lib; {
    description = "LLM plugin for interacting with the Claude 3 family of models";
    homepage = "https://github.com/simonw/llm-claude-3";
    license = licenses.asl20;
    maintainers = with maintainers; [ jrmeland ];
  };
}
