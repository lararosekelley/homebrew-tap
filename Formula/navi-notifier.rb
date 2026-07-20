class NaviNotifier < Formula
  desc "A friendly helper to guide you through the day-to-day noise of code review."
  homepage "https://github.com/lararosekelley/navi"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.1.9/navi-notifier-aarch64-apple-darwin.tar.xz"
      sha256 "116d0aa7e918aeca13887aad5e60af3d348313a49677e3c2851f3787ad272854"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.1.9/navi-notifier-x86_64-apple-darwin.tar.xz"
      sha256 "c08964a890565805d83e23d17617e3abf6c08b6b68040a6790130f708822f4d1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.1.9/navi-notifier-aarch64-unknown-linux-musl.tar.xz"
      sha256 "1950865c372d8f9c08926ea52e09743d60b732b8c28e1595cae641b8f3a55bc6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.1.9/navi-notifier-x86_64-unknown-linux-musl.tar.xz"
      sha256 "e2ad951d7f53e1180b244c55d4419f5f8ee269634e56471f21a2993f79bb14a3"
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
