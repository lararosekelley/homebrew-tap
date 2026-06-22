class GitStk < Formula
  desc "Git-native stacked branch workflow helper"
  homepage "https://larakelley.com/posts/git-stk"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.10.0/git-stk-aarch64-apple-darwin.tar.xz"
      sha256 "6657aa8f19046aebff80e120b0e5caecb6f5e9e88856034e31795c6bb3abd068"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.10.0/git-stk-x86_64-apple-darwin.tar.xz"
      sha256 "60047a0912f6db26e7f99c8d4b6f0cf8583e1ba369f58e3c6bf0a5c8a8247165"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.10.0/git-stk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "dd4b7655bdd61411bd9492c585be281409be559b0aa0a242417ac4110e352180"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.10.0/git-stk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5cbcd1aaaf94aa0aac182cfe1ca0418a4f390dc501b44bf285e421ad79624b9e"
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
