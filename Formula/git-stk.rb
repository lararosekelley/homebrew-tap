class GitStk < Formula
  desc "Git-native stacked branch workflow helper"
  homepage "https://larakelley.com/posts/git-stk"
  version "0.16.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.16.7/git-stk-aarch64-apple-darwin.tar.xz"
      sha256 "19bd245697b3563136ce049b80b7c00b0f812b9df604d04024232168e3164846"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.16.7/git-stk-x86_64-apple-darwin.tar.xz"
      sha256 "a84a29637947037b0eb599b893cc38424f4edcabb28feedbc8a48de16301278b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.16.7/git-stk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "b0beb53ce30bfb074917109a3363538add994cfd5660e7199bab72f89ccab14b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.16.7/git-stk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "74898fb5758d5d682d3e0a1df00dcd7feffc4432f6400c9879493033b00ad63e"
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
