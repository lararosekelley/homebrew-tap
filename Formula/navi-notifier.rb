class NaviNotifier < Formula
  desc "A friendly helper to guide you through the day-to-day noise of code review."
  homepage "https://github.com/lararosekelley/navi"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.4.1/navi-notifier-aarch64-apple-darwin.tar.xz"
      sha256 "669b6576ba12f1a72e7d3b5e1239284930dbd29f9ac60e30ca07ed64eb8aea29"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.4.1/navi-notifier-x86_64-apple-darwin.tar.xz"
      sha256 "de68cdb628093107c0feeb207ceb4d80c08733630ab28466b1a9af2a53d15a8f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.4.1/navi-notifier-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f2c7671aef49f67addc72eda84265c53ce161203d5ff52b36bb68f474738efae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.4.1/navi-notifier-x86_64-unknown-linux-musl.tar.xz"
      sha256 "241b3100e1ad7c6c34ee5f04f02a97f4df5957b8346299d3e53a1973d19d5ca5"
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
