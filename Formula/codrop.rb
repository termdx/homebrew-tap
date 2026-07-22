class Codrop < Formula
  desc "Codrop live-sync daemon: watch a folder and sync changes to peers over iroh."
  homepage "https://github.com/termdx/Codrop"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/termdx/Codrop/releases/download/v0.1.2/codrop-aarch64-apple-darwin.tar.xz"
      sha256 "62a4a5f61716f1ca456514bfdc1b302d0128c43f4ea3fcdde548729412a9523c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/termdx/Codrop/releases/download/v0.1.2/codrop-x86_64-apple-darwin.tar.xz"
      sha256 "c6cbac7cb096fe3af12ce9b7b7fc7edc2f5dfbb5766980e0f2160346df04402f"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/termdx/Codrop/releases/download/v0.1.2/codrop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6b5961b271bbf25add6b1edf049f5604226175a425498211cd38ad59deb6fb97"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
      bin.install "codrop"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "codrop"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "codrop"
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
