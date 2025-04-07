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

  services.postgres = {
    enable = true;
    settings = {
      max_connections                    = 40;
      shared_buffers                     = "25GB";
      effective_cache_size               = "75GB";
      maintenance_work_mem               = "2GB";
      checkpoint_completion_target       = 0.9;
      wal_buffers                        = "16MB";
      default_statistics_target          = 100;
      random_page_cost                   = 1.1;
      effective_io_concurrency           = 200;
      work_mem                           = "160MB";
      huge_pages                         = "try";
      min_wal_size                       = "1GB";
      max_wal_size                       = "4GB";
      max_worker_processes               = 40;
      max_parallel_workers_per_gather    = 4;
      max_parallel_workers               = 40;
      max_parallel_maintenance_workers   = 4;
    };
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
    tzdata
  ];

  languages.ruby.enable = true;
  languages.ruby.versionFile = ./.ruby-version;
}
