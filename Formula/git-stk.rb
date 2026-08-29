class GitStk < Formula
  desc "Git-native stacked branch workflow helper"
  homepage "https://larakelley.com/posts/git-stk"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.12.0/git-stk-aarch64-apple-darwin.tar.xz"
      sha256 "6f9f02df360ac6d0638f2273aa801f529cf7b0c1623331d549161d431f0a0aad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.12.0/git-stk-x86_64-apple-darwin.tar.xz"
      sha256 "f9f0967d30b6ef3e69712044ecd423e6307d3c02e5815e257b939727d55eadd7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.12.0/git-stk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "48f8b48e074d60f34cd80d1ec89d97228aa55410e4a691ab5a616acb0150824d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.12.0/git-stk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ef0264bed880c6b6a549418497bc6205de7c097d9f46daa0fcbc1330d96941ff"
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
