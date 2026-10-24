class Opencrs < Formula
  desc "Tooling for OpenCRS, the Open Creative Requirements Specification"
  homepage "https://opencrs.dev"
  version "0.1.0-rc.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.0-rc.3/opencrs-cli-aarch64-apple-darwin.tar.xz"
      sha256 "29c9872e51f5e8e569d9b8fe0282bf278ed4236c080050e0a87c13187122a0d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.0-rc.3/opencrs-cli-x86_64-apple-darwin.tar.xz"
      sha256 "758be9bdbd39844bec29a8fee1a7295e37cc3af1d9c7fe4fd8ebbdc2982db980"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.0-rc.3/opencrs-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bb2105ab372aa00bc0f3635f22bc4dd8d7a5d1ed4bc5e0cf8d6f869adf8b909e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.0-rc.3/opencrs-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3d418c1bdc67051c4f8e6d328d3dcb088e4f0452b272cf006b67ff75ce941675"
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
