class NaviNotifier < Formula
  desc "A friendly helper to guide you through the day-to-day noise of code review."
  homepage "https://github.com/lararosekelley/navi"
  version "0.3.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.5/navi-notifier-aarch64-apple-darwin.tar.xz"
      sha256 "fb953bcfa590e2d0737b4f105ec418af0dd73620b49f94965491dc74f4329a31"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.5/navi-notifier-x86_64-apple-darwin.tar.xz"
      sha256 "1dda333ba893fab7fd948f71c3b43dcb0ef70166db8b07f0986c3b76367d1726"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.5/navi-notifier-aarch64-unknown-linux-musl.tar.xz"
      sha256 "b4127151d902f7cbfc48a849b46ffe9b62da80955015a68676f5c2034dfdb40a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.3.5/navi-notifier-x86_64-unknown-linux-musl.tar.xz"
      sha256 "7fb9e516c6090c464553de5f2088d9b7c5d40090391ee8caa91c31b2d3ab6af2"
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
