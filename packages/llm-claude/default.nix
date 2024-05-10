{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, anthropic
, click
, pytest
}:

buildPythonPackage rec {
  pname = "llm-claude";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tomviner";
    repo = "llm-claude";
    rev = version;
    hash = "sha256-lC0Tx7zeM8gZ3Ln8VWkq29BsKsMnxHB3s+R086B5BEs=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    anthropic
  ];

  passthru.optional-dependencies = {
    test = [
      click
      pytest
    ];
  };

  dontCheckRuntimeDeps = true;

  meta = with lib; {
    description = "Plugin for LLM adding support for Anthropic's Claude models";
    homepage = "https://github.com/tomviner/llm-claude";
    license = licenses.asl20;
    maintainers = with maintainers; [ jrmeland ];
  };
}
