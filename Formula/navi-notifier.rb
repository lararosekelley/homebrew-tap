class NaviNotifier < Formula
  desc "A friendly helper to guide you through the day-to-day noise of code review."
  homepage "https://github.com/lararosekelley/navi"
  version "0.3.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.6/navi-notifier-aarch64-apple-darwin.tar.xz"
      sha256 "42e649e6042b18ae37717bcefd99d9e4699c793389cbb19f2345a998fdbf859f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.6/navi-notifier-x86_64-apple-darwin.tar.xz"
      sha256 "816367d8ce6f5edc69cd80c5fd30df02ccac681f88c5f26a65a73ad63ff94c5e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.6/navi-notifier-aarch64-unknown-linux-musl.tar.xz"
      sha256 "6c93bbef94b35e8080ed33e56388464607ef4c776ef6b0a581a873a5832e284b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.6/navi-notifier-x86_64-unknown-linux-musl.tar.xz"
      sha256 "c1e5a2619bfc40431b0599d8040532b74e1ed5b62a415922c47e4bfc8dbaae66"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "navi"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "navi"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "navi"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "navi"
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
