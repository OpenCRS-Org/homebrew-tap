class Opencrs < Formula
  desc "Tooling for OpenCRS, the Open Creative Requirements Specification"
  homepage "https://opencrs.dev"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.3/opencrs-cli-aarch64-apple-darwin.tar.xz"
      sha256 "784bbde790a3d2aef7923862b0f929f50944b06b14d32ee9f80c189903bc448b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.3/opencrs-cli-x86_64-apple-darwin.tar.xz"
      sha256 "277d1194a5eac5fd1dfb954e138a55d90cc8c6e7a21316279a847642d8cdedab"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.3/opencrs-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bcc5d579f7c6fe39a2626df596ce0a69b2beeb2f2e639a1be744f6829fcbd43c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.3/opencrs-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d037925969099b0324ccd42518ca60bb9ec9cccb3744c885576528b455b4f35"
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
    man1.install "man/opencrs.1"
    bash_completion.install "completions/opencrs.bash" => "opencrs"
    zsh_completion.install "completions/_opencrs"
    fish_completion.install "completions/opencrs.fish"

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
