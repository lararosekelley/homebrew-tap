class NaviNotifier < Formula
  desc "A friendly helper to guide you through the day-to-day noise of code review."
  homepage "https://github.com/lararosekelley/navi"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.2.2/navi-notifier-aarch64-apple-darwin.tar.xz"
      sha256 "75eb7a5c3031065b03166fb2012e45a6e46fe87ed132d07f83d2989fa611da49"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.2.2/navi-notifier-x86_64-apple-darwin.tar.xz"
      sha256 "5fee3417f5ba00eeecd83602b0964aee9402e0a90b36ec3b41f09f6831fe8802"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.2.2/navi-notifier-aarch64-unknown-linux-musl.tar.xz"
      sha256 "bf7bdf1c67419450bf6aaff2a33ecf95fed9d56dee46851bc3017c1f62bdea25"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.2.2/navi-notifier-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5da5000aef1d44413599b79a723c54b20bd94534f1d2ac546141e86f3f6b5ec4"
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
