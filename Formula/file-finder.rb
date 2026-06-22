class FileFinder < Formula
  desc "CLI to find files in a directory tree based on various criteria"
  homepage "https://github.com/issy/file-finder"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/issy/file-finder/releases/download/0.2.0/file-finder-aarch64-apple-darwin.tar.xz"
      sha256 "1dd00b473b39c8236634d81d50b34cc19b7b2845930a3407377f3301771bd479"
    end
    if Hardware::CPU.intel?
      url "https://github.com/issy/file-finder/releases/download/0.2.0/file-finder-x86_64-apple-darwin.tar.xz"
      sha256 "4f708f53eac4db6da54926ada59af449a0045c57e188acee50b4be4c1d032170"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/issy/file-finder/releases/download/0.2.0/file-finder-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "81137113ce9a3e1bd358096e7922fc22b0485d43359a15c72a94674fce8bb6d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/issy/file-finder/releases/download/0.2.0/file-finder-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e496d446de403c817bfb72402a45000b69cadb9f862a71e6d66ad841b4ed341e"
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
