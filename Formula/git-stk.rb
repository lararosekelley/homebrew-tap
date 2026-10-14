class GitStk < Formula
  desc "Git-native stacked branch workflow helper"
  homepage "https://larakelley.com/posts/git-stk"
  version "0.15.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.15.2/git-stk-aarch64-apple-darwin.tar.xz"
      sha256 "3957193401a68457c05ee1e01f3ed1722f6a2e6652795419cb05a452085287ac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.15.2/git-stk-x86_64-apple-darwin.tar.xz"
      sha256 "662ebe4336b4d80a0045c7924404150041384a2e19159e0a214b08130df77afc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.15.2/git-stk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "a75929ca47b1e4a064133ef2f061b199f99e09eaaf0934be190e5de4fa3d0509"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.15.2/git-stk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "eb1f604a5bfc6c1504dee08f475f169ebe8e6d47d50a48a4298d5bdeaa778966"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
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
      bin.install "git-stk"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "git-stk"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "git-stk"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "git-stk"
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
