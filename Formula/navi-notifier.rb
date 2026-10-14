class NaviNotifier < Formula
  desc "A friendly helper to guide you through the day-to-day noise of code review."
  homepage "https://github.com/lararosekelley/navi"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.4.0/navi-notifier-aarch64-apple-darwin.tar.xz"
      sha256 "70d3cb30b3e3de966f8fb2cc7d9cb9571db9002d8d43e0467e10bceebe03e524"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.4.0/navi-notifier-x86_64-apple-darwin.tar.xz"
      sha256 "a310c55a8617199323c481964eb44e2bfda8bbef15e09db3c80bb25b03da803d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.4.0/navi-notifier-aarch64-unknown-linux-musl.tar.xz"
      sha256 "12ef3064a7cd9d0fb31d7f865b9209e597ee287cd896685e585e68707f5c2314"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.4.0/navi-notifier-x86_64-unknown-linux-musl.tar.xz"
      sha256 "055f6e8843a6c0609d193e8b23db9934624e26f2fc910e6687fb3b5a77783929"
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
