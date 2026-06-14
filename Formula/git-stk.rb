class GitStk < Formula
  desc "Git-native stacked branch workflow helper"
  homepage "https://larakelley.com/posts/git-stk"
  version "0.9.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.9.10/git-stk-aarch64-apple-darwin.tar.xz"
      sha256 "d15defe9adf1e18c1ae4d558a25d17e2968732a5b09210580c06e1e56906ed5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.9.10/git-stk-x86_64-apple-darwin.tar.xz"
      sha256 "9b17a989bcdfa5ace6644bf1a19027bfe4a42525ea076f4ec64aae692f8b11ef"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.9.10/git-stk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "8b55a574bfe57a4988b6e75d8ab4a7e0f586e26c402cd5a619797b9bf41a49d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.9.10/git-stk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "9319c93dcd66368fa765d5a537eedd36f6296338bfd5ce50b7d8744356a1a74f"
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
    bin.install "git-stk" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-stk" if OS.mac? && Hardware::CPU.intel?
    bin.install "git-stk" if OS.linux? && Hardware::CPU.arm?
    bin.install "git-stk" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
