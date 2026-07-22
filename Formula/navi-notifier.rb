class NaviNotifier < Formula
  desc "A friendly helper to guide you through the day-to-day noise of code review."
  homepage "https://github.com/lararosekelley/navi"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.2.3/navi-notifier-aarch64-apple-darwin.tar.xz"
      sha256 "ebaf77f699b13e4349bc12cc7231b3d9f9262b6ace6dc4c9d590b2b19565198d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.2.3/navi-notifier-x86_64-apple-darwin.tar.xz"
      sha256 "45273b1a791cb008022bb1120fd752fcfaa2f0ba71a64302eaf1a614862a6f24"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lararosekelley/navi/releases/download/v0.2.3/navi-notifier-aarch64-unknown-linux-musl.tar.xz"
      sha256 "21b01bc7f0fc73023e8c9f35d1f34697856501b758453706a4e43dc263ea4a8d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lararosekelley/navi/releases/download/v0.2.3/navi-notifier-x86_64-unknown-linux-musl.tar.xz"
      sha256 "294839c15f8576b87f1801133cf2a093cb8fa9a81783d4f20c28aa3345d86b6c"
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
