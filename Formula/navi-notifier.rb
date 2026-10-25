class NaviNotifier < Formula
  desc "A friendly helper to guide you through the day-to-day noise of code review."
  homepage "https://github.com/lararosekelley/navi"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.5.0/navi-notifier-aarch64-apple-darwin.tar.xz"
      sha256 "b7da6ae3c29b68092ad5b8338c212e7b87fcb6ddd94537faf49219cbcc733063"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.5.0/navi-notifier-x86_64-apple-darwin.tar.xz"
      sha256 "d5aa85afbea23a7027abf641a40bdcc5fe764718b2305b730a11f341f7a41905"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.5.0/navi-notifier-aarch64-unknown-linux-musl.tar.xz"
      sha256 "8163139b49bc88e530f318eb60b74dc8a7a005a7c6511375a70348bc6925f8ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.5.0/navi-notifier-x86_64-unknown-linux-musl.tar.xz"
      sha256 "76e57aed2d6de5f62e1b355c105dead004ab436a218bcb56a66aed0ab54c53e2"
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
