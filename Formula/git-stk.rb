class GitStk < Formula
  desc "Git-native stacked branch workflow helper"
  homepage "https://larakelley.com/posts/git-stk"
  version "0.16.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.16.0/git-stk-aarch64-apple-darwin.tar.xz"
      sha256 "9c554929d0ea37d6fb8741f2eea002220f9cc8bb76a957357c2264727185b639"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.16.0/git-stk-x86_64-apple-darwin.tar.xz"
      sha256 "8b94b5f056a43861c247a59a74fbf01766e305292f74ff1a12be347ac052fbf8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.16.0/git-stk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "631b6cb2e432983aa22609aea86d14854d277445f01d13f7c924471c6e4e03fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.16.0/git-stk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "1151f3005aa431187184b5b608b9db9c0fe5ccd4fe82bb0ae32b946d100a207a"
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
