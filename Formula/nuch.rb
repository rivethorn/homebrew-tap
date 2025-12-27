class Nuch < Formula
  desc "A CLI to manage Markdown content and images for Nuxt Content sites."
  homepage "https://github.com/rivethorn/nuch"
  version "1.3.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rivethorn/nuch/releases/download/v1.3.6/nuch-aarch64-apple-darwin.tar.xz"
      sha256 "97999f0339421d604fbf7ee16f5f4c4fd798cfebef6ff75079ba1f080dded25e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rivethorn/nuch/releases/download/v1.3.6/nuch-x86_64-apple-darwin.tar.xz"
      sha256 "a728dc0607103026065efbc57117a7db4431cde6334ac06b84a7e26b36581a93"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rivethorn/nuch/releases/download/v1.3.6/nuch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9d117c449c464cb60672d4de11022fb31ed91ff7ab95ef63049eb969f7a1a01a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rivethorn/nuch/releases/download/v1.3.6/nuch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0732a9610b5e961304a0b9a4ad6f628f1cca92376e90ba08bbf2b6a391debd01"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "nuch" if OS.mac? && Hardware::CPU.arm?
    bin.install "nuch" if OS.mac? && Hardware::CPU.intel?
    bin.install "nuch" if OS.linux? && Hardware::CPU.arm?
    bin.install "nuch" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
