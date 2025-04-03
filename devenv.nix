{ config, pkgs, ... }:

with pkgs; {
  env = {
    LD_LIBRARY_PATH = "${config.devenv.profile}/lib";
    DISABLE_DATABASE_ENVIRONMENT_CHECK = "1";
    RAILS_LOG_LEVEL = "warn";
    RUBY_YJIT_ENABLE = "1";
    SECRET_KEY_BASE = "asdf";
    RAILS_ENV = "production";
  };

  packages = [
    git
    libyaml
    sqlite-interactive
    vips
    imagemagick
    ffmpeg
    openssl
    poppler
    poppler_utils
    hey
  ];

  languages.ruby.enable = true;
  languages.ruby.versionFile = ./.ruby-version;
}
