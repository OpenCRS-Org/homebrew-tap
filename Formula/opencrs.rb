class Opencrs < Formula
  desc "Tooling for OpenCRS, the Open Creative Requirements Specification"
  homepage "https://opencrs.dev"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.0/opencrs-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4be66f5d7e739788d212bd06827ede87a0861396205b8119f1833b6a413e2183"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.0/opencrs-cli-x86_64-apple-darwin.tar.xz"
      sha256 "de61b945a3f8ccc1937ba09c2381385eb41c1302bb7dd5da7c40eb21bd29356e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.0/opencrs-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7ea434325c6931e96308bbc8d933fc205cbbc35f8e30b218afdad070cb57d332"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OpenCRS-Org/opencrs/releases/download/v0.1.0/opencrs-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e62a1d543b41576653479b3dcbf4aa3ed982eecdeeba3f3d9193bd773e292897"
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
