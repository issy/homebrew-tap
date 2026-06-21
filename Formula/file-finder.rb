class FileFinder < Formula
  desc "CLI to find files in a directory tree based on various criteria"
  homepage "https://github.com/issy/file-finder"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/issy/file-finder/releases/download/0.1.1/file-finder-aarch64-apple-darwin.tar.xz"
      sha256 "e0df4cead9b69950c5a566a5538dbfe89b87f103b8a2dc7ce51aa979f8d3b09f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/issy/file-finder/releases/download/0.1.1/file-finder-x86_64-apple-darwin.tar.xz"
      sha256 "3abc2ec39db5276610de3cea2b16ba62e4ed23acba46b06971e4080243b30d0a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/issy/file-finder/releases/download/0.1.1/file-finder-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9c6b1c9a70713883239ddaf4188c7d7aec139791301c48b552a8cf86933880f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/issy/file-finder/releases/download/0.1.1/file-finder-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a93f3ff1fe4e9d5f0e0f27e76d38f5345d7d51b5b5f924f8fa327031f5c02d72"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "file-finder" if OS.mac? && Hardware::CPU.arm?
    bin.install "file-finder" if OS.mac? && Hardware::CPU.intel?
    bin.install "file-finder" if OS.linux? && Hardware::CPU.arm?
    bin.install "file-finder" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
