class FileFinder < Formula
  desc "CLI to find files in a directory tree based on various criteria"
  homepage "https://github.com/issy/file-finder"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/issy/file-finder/releases/download/0.5.0/file-finder-aarch64-apple-darwin.tar.xz"
      sha256 "079f7fb042b09f099bfc28ade14cefae69ed47313dde0ed9c5559b0d65a96271"
    end
    if Hardware::CPU.intel?
      url "https://github.com/issy/file-finder/releases/download/0.5.0/file-finder-x86_64-apple-darwin.tar.xz"
      sha256 "1d199d68074c6128fd1dff39ffa72c13ed0da1692e3b61f04b96b0d6df50eb28"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/issy/file-finder/releases/download/0.5.0/file-finder-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "595be496327d2a19c868eaed6dc44913bb0fc7a7f371cd6238d2552a71a165b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/issy/file-finder/releases/download/0.5.0/file-finder-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a0674a6d6e94d1f40fa600745923353b4b28ad76550a186508b94c775d230038"
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
