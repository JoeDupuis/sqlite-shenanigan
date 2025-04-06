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

  scripts."mount-ram".exec = ''
    MOUNT_DIR="./storage"
    SIZE_MB=512

    mkdir -p "$MOUNT_DIR"

    if [[ "$(uname)" == "Darwin" ]]; then
      echo "📦 macOS detected — creating RAM disk at $MOUNT_DIR (''${SIZE_MB}MB)..."
      BLOCKSIZE=2048
      BLOCKS=$(expr ''${SIZE_MB} \* ''${BLOCKSIZE})
      DEVICE=$(hdiutil attach -nomount ram://''${BLOCKS})
      diskutil erasevolume HFS+ "RAMDisk" "''${DEVICE}"
      sudo mount -t hfs "''${DEVICE}" "$MOUNT_DIR"
      echo "✅ RAM disk mounted at $MOUNT_DIR"
    elif [[ "$(uname)" == "Linux" ]]; then
      echo "📦 Linux detected — mounting tmpfs at $MOUNT_DIR (''${SIZE_MB}MB)..."
      sudo mount -t tmpfs -o size=''${SIZE_MB}M tmpfs "$MOUNT_DIR"
      echo "✅ tmpfs mounted at $MOUNT_DIR"
    else
      echo "🛑 Unsupported OS: $(uname)"
      exit 1
    fi
  '';

  scripts."unmount-ram".exec = ''
    MOUNT_DIR="./storage"

    if mount | grep -q "on $MOUNT_DIR "; then
      echo "🧹 Unmounting RAM disk at $MOUNT_DIR..."
      sudo umount "$MOUNT_DIR"
      echo "✅ Unmounted successfully."
    else
      echo "ℹ️ Nothing mounted at $MOUNT_DIR."
    fi
  '';

  services.postgres.enable = true;

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
    tzdata
  ];

  languages.ruby.enable = true;
  languages.ruby.versionFile = ./.ruby-version;
}
