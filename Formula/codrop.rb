class Codrop < Formula
  desc "Codrop live-sync daemon: watch a folder and sync changes to peers over iroh."
  homepage "https://github.com/termdx/Codrop"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/termdx/Codrop/releases/download/v0.1.1/codrop-aarch64-apple-darwin.tar.xz"
      sha256 "ee4d622dea214c2db5a1cd91140886a89a06f7a96e7d68b98913d7e26e6f54aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/termdx/Codrop/releases/download/v0.1.1/codrop-x86_64-apple-darwin.tar.xz"
      sha256 "ad8c31b1ff5f54b517c405901fce0524483bbcdf671c57e56b13c2f53a446e44"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/termdx/Codrop/releases/download/v0.1.1/codrop-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2d62b9b4419de373e49e47cb8ebf5bbd82b665b62acd1f384ef73c47e6dd2799"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "codrop" if OS.mac? && Hardware::CPU.arm?
    bin.install "codrop" if OS.mac? && Hardware::CPU.intel?
    bin.install "codrop" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
