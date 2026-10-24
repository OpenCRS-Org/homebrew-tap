class Opencrs < Formula
  desc "Tooling for OpenCRS, the Open Creative Requirements Specification"
  homepage "https://opencrs.dev"
  version "0.1.0-rc.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.0-rc.2/opencrs-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3b346c57fcb65318fc98bee7d700f44cec33376931b0d12f17e5908abc481c8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.0-rc.2/opencrs-cli-x86_64-apple-darwin.tar.xz"
      sha256 "941f1bb362da2013d8b28e36b1875a2baeb3d49a3a93381f7f51a0a0e19e283b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.0-rc.2/opencrs-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1a8b2ff659a8be459b7c90f9b05b3535d3f7322088c399b065ee4609ba39da75"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.0-rc.2/opencrs-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "33fe6431b84bb2e23caf99824388ee23e520e9598d6b050aaae3c9b30390a1bc"
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
