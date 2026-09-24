class Dustpan < Formula
  desc "Find and clean the dev leftovers eating your Mac's disk and memory: stale worktrees, orphaned DerivedData, simulators, caches"
  homepage "https://github.com/cmlarsen/dustpan"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cmlarsen/dustpan/releases/download/v0.1.1/dustpan-aarch64-apple-darwin.tar.xz"
      sha256 "1fee23a662af9bb7280c32cf54a4f7c855ae89042acd84462a55c94fee1aaf4d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmlarsen/dustpan/releases/download/v0.1.1/dustpan-x86_64-apple-darwin.tar.xz"
      sha256 "0818d4a82636a727dff9fd174fce613776b0a0f24a9ead2189520a4a9cccabe9"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {
      dp: [
        "dustpan",
      ],
    },
    "x86_64-apple-darwin":  {
      dp: [
        "dustpan",
      ],
    },
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "dp"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dp"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
