class NaviNotifier < Formula
  desc "A friendly helper to guide you through the day-to-day noise of code review."
  homepage "https://github.com/lararosekelley/navi"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.0/navi-notifier-aarch64-apple-darwin.tar.xz"
      sha256 "d096252debd897e9dbef707cbf8d5943fdb12e437bf3693acaaab8b6e6ce96f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.0/navi-notifier-x86_64-apple-darwin.tar.xz"
      sha256 "c6aed154dd73c9f51159af976e4435088fc86a61ce7bc7e5f33563cfba21927a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.0/navi-notifier-aarch64-unknown-linux-musl.tar.xz"
      sha256 "ac3157477c46419382355ce30f2525ec9795dcd38327b42f6167afd5352f5ad5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.0/navi-notifier-x86_64-unknown-linux-musl.tar.xz"
      sha256 "bce02011ab6738b1820fbaa94f910003a3e9a72e526a489b65cb32e880760cda"
    end
  end
  license "MIT"

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
    bin.install "navi" if OS.mac? && Hardware::CPU.arm?
    bin.install "navi" if OS.mac? && Hardware::CPU.intel?
    bin.install "navi" if OS.linux? && Hardware::CPU.arm?
    bin.install "navi" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
