class GitStk < Formula
  desc "Git-native stacked branch workflow helper"
  homepage "https://larakelley.com/posts/git-stk"
  version "0.9.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.9.8/git-stk-aarch64-apple-darwin.tar.xz"
      sha256 "477d248fbcc8ef7cfde54514cc35856e73f4a3560c362cc6b9d8069821d5c941"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.9.8/git-stk-x86_64-apple-darwin.tar.xz"
      sha256 "b697671b17f6077b661dc989ec2eea3eea4f121396920d11dd9a54afab6f1d8d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.9.8/git-stk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "2181943abcf523bb837291ffcccb4ebccf15c92de1ce80181d6cf651b73419b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.9.8/git-stk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "a06da41b068cada58b335ebdb916420ee1da82516ab1ce8636d89683cc63f5bb"
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
