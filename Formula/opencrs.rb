class Opencrs < Formula
  desc "Tooling for OpenCRS, the Open Creative Requirements Specification"
  homepage "https://opencrs.dev"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.2/opencrs-cli-aarch64-apple-darwin.tar.xz"
      sha256 "871e2e80343bc616d4c5d9ba810e1c96640b582ec2ce4444b3e0094f6e46c00f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.2/opencrs-cli-x86_64-apple-darwin.tar.xz"
      sha256 "51ae18926d3f10575185a462b298174af1fe035d109a04ddf865fcb3436d9eac"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.2/opencrs-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0ada15c96458ed09922a0d6ccac952f95b9f9c1607b4bbf5994289c1d99094f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.2/opencrs-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c384eed488d547d6748eb442c86579e6c1a2507e0e4ac9d5fd4af401402b8294"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-pc-windows-gnu":             {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
      bin.install "opencrs"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "opencrs"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "opencrs"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "opencrs"
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
