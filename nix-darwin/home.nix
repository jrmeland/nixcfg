{ config, pkgs, ... }:


let
  # Keep this around as an exmaple of overlay

  llm = pkgs.python311Packages.llm.overridePythonAttrs (oldPython: rec {
    version = "0.14";
    src = pkgs.fetchFromGitHub {
      owner = "simonw";
      repo = "llm";
      rev = "refs/tags/0.14";
      hash = "sha256-CgGVFUsntVkF0zORAtYQQMAeGtIwBbj9hE0Ei1OCGq4=";
    };
  });
  # llm-claude = pkgs.python311Packages.callPackage ../packages/llm-claude/default.nix { };
  # llm-claude-3 = pkgs.python311Packages.callPackage ../packages/llm-claude-3/default.nix {
  #   inherit llm-claude;
  # };
  # llmWithPlugins = (llm.withPlugins [ llm-claude-3 ]).overridePythonAttrs (oldPython: {
  #     version = "0.14";
  #     src = pkgs.fetchFromGitHub { 
  #       owner = "simonw"; 
  #       repo = "llm"; 
  #       rev = "refs/tags/0.14"; 
  #       hash = "sha256-CgGVFUsntVkF0zORAtYQQMAeGtIwBbj9hE0Ei1OCGq4="; };
  #   });
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "josh";
  home.homeDirectory = "/Users/josh";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.hello
    pkgs.nixpkgs-fmt
    pkgs.nil
    pkgs.nix-init
    pkgs.manix
    pkgs.direnv
    pkgs.pngquant
    pkgs.cocoapods
    pkgs.pyenv



    # llmWithPlugins
    llm


    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/josh/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
    TEST_ENV_VAR = "josh";
    PYENV_ROOT = "$HOME/.pyenv";
    PATH = "$PYENV_ROOT/bin:$PATH";
  };

  home.shellAliases = {
    gs = "git status";
  };


  programs.zsh = {
    enable = true; # default shell on catalina
    enableCompletion = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;

    };


    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
      extraConfig = ''


      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      '';
    };

    plugins = [
      {
        # will source zsh-completions.plugin.zsh
        name = "zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "0.35.0";
          sha256 = "sha256-GFHlZjIHUWwyeVoCpszgn4AmLPSSE8UVNfRmisnhkpg=";
        };
      }
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "v1.1.2";
          sha256 = "sha256-Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
        };
      }
    ];

    initExtra = ''
      # Fuck it do it myself
      source /run/current-system/sw/etc/profile.d/nix-daemon.sh
      source /run/current-system/sw/etc/profile.d/nix.sh
      export PATH=/etc/profiles/per-user/josh/bin:$PATH

      # Initialize pyenv
      eval "$(pyenv init -)"

      llm models default 4o
      eval "$(direnv hook zsh)"
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

      alias login_github_registry="gh auth token | docker login ghcr.io -u jrmeland --password-stdin"
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
