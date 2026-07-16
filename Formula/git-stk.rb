class GitStk < Formula
  desc "Git-native stacked branch workflow helper"
  homepage "https://larakelley.com/posts/git-stk"
  version "0.10.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.10.6/git-stk-aarch64-apple-darwin.tar.xz"
      sha256 "8ed909fae3607cbebc2c972cf94d0585fc31ff54734c20fd598a12be44d3e75a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.10.6/git-stk-x86_64-apple-darwin.tar.xz"
      sha256 "b9bc6adea019cba272ca8752db0d2b5fbefab3929fc06e47a3fde214ec18be92"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.10.6/git-stk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "d2be0c504efff7188d23999e007917510f8db596c298a09d141047b4750c57d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.10.6/git-stk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "bddc528e5eaca27de9947b12df4196d300f78f2c47a25ddff00a06dd2b798ff5"
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
