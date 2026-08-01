class GitStk < Formula
  desc "Git-native stacked branch workflow helper"
  homepage "https://larakelley.com/posts/git-stk"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.11.0/git-stk-aarch64-apple-darwin.tar.xz"
      sha256 "99d7b588149671fd293fee449f8f50630dd2daa85bb60152dc16cc360e4d0509"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.11.0/git-stk-x86_64-apple-darwin.tar.xz"
      sha256 "6fee81f2a81ddaf8a8805bee11cf8438c88ca8c65ce3d16977d0045c87d74c67"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.11.0/git-stk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "9ace2afc27bf2cdff59023654138c7761bf2bb581a4d05c86d63c81c1bb4d60d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/git-stk/releases/download/v0.11.0/git-stk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "043ec0e25a977b74607e28b18f87a5b40d32554aedbb111442b73bcb3d306267"
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
