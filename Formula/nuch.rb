class Nuch < Formula
  desc "A CLI to manage Markdown content and images for Nuxt Content sites."
  homepage "https://github.com/rivethorn/nuch"
  version "1.3.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rivethorn/nuch/releases/download/v1.3.5/nuch-aarch64-apple-darwin.tar.xz"
      sha256 "7f692ddf9fa1c8e214a237b40ca851d6895bf061616d491c6439bfc22ca13732"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rivethorn/nuch/releases/download/v1.3.5/nuch-x86_64-apple-darwin.tar.xz"
      sha256 "4123996c39a402af1462b564912fbe00cfa6e197f62dbbbb4658ae718d80d6ba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rivethorn/nuch/releases/download/v1.3.5/nuch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f81ecea206d04dcaf156d6a75333a00b1f795213d59850d602800ee67bb2593f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rivethorn/nuch/releases/download/v1.3.5/nuch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b03aede1f37da4c65c7385a52f71d529a321c09b969ea670e4441fa91f2491f5"
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
