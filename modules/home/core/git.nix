# git + jujutsu (-> ~/.config/git/config).
#
# Work identity (host + email) lives in secrets/work.yaml. sops-nix's home-manager
# module renders it into a git config include at login, so it works on NixOS and
# on the standalone work laptop. Needs an age key at ~/.config/sops/age/keys.txt.
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  ph = config.sops.placeholder;
  workSecret = {
    sopsFile = ../../../secrets/work.yaml;
  };
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    secrets."git/work-host" = workSecret;
    secrets."git/work-email" = workSecret;
    templates."git-work.inc".content = ''
      [includeIf "hasconfig:remote.*.url:${ph."git/work-host"}/**"]
      	path = ${config.sops.templates."git-work-user.inc".path}
    '';
    templates."git-work-user.inc".content = ''
      [user]
      	email = ${ph."git/work-email"}
    '';
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "aurelientollard";
        email = "tollard.aurelien1999@gmail.com";
      };
      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        psu = "push -u origin HEAD";
        ps = "push";
        wip = ''commit -am "WIP"'';
      };
      init.defaultBranch = "main";
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
    };
    # Work identity for repos hosted on the company forge (rendered from sops;
    # git skips it until it exists).
    includes = [ { path = config.sops.templates."git-work.inc".path; } ];
  };
}
