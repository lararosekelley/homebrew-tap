class NaviNotifier < Formula
  desc "A friendly helper to guide you through the day-to-day noise of code review."
  homepage "https://github.com/lararosekelley/navi"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.3/navi-notifier-aarch64-apple-darwin.tar.xz"
      sha256 "6ee566d1b202e94e5ef4b9d9e1e501516d06b90f15af875c556050154c32067a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.3/navi-notifier-x86_64-apple-darwin.tar.xz"
      sha256 "1dee9aadb5a14dfecf7152ac55e6a6266766ff843b40a97baffa8b69a96d480f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.3/navi-notifier-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f9c39c114bec4af39ef91d915fc39afd9dd2054a5c92d45081dae63aeed15c20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.3/navi-notifier-x86_64-unknown-linux-musl.tar.xz"
      sha256 "1353c47c459bad8fc952aaeb64a05d067bb980d4a92b71f60eb7e7477009b3af"
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
