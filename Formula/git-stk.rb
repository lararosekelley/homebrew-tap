class GitStk < Formula
  desc "Git-native stacked branch workflow helper"
  homepage "https://larakelley.com/posts/git-stk"
  version "0.13.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.13.2/git-stk-aarch64-apple-darwin.tar.xz"
      sha256 "bd8dbc083183cc287f7850c37c88e77cdc6caf70e9fe8d9c140fdc80a4338338"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.13.2/git-stk-x86_64-apple-darwin.tar.xz"
      sha256 "62b643f2d3b3149c717a497beb76b5f58e72f3b73cf49399bc9d9260f3fd2740"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.13.2/git-stk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f13c39fa8c9b5d8eb074377083ec53c1bde313acb061aad1a41802cd6c4520ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.13.2/git-stk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "1dfc426bc02e319289762387e55f891a48a7c4b9d7c72cec4211cc99cdb66bfa"
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
