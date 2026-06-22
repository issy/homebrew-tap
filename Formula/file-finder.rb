class FileFinder < Formula
  desc "CLI to find files in a directory tree based on various criteria"
  homepage "https://github.com/issy/file-finder"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/issy/file-finder/releases/download/0.4.0/file-finder-aarch64-apple-darwin.tar.xz"
      sha256 "b6d4d37194dd9bd996be9e752b13633ad78e8fd2839f1ebb1766d19c644b410a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/issy/file-finder/releases/download/0.4.0/file-finder-x86_64-apple-darwin.tar.xz"
      sha256 "231a9b16f9b9799ced397b2331217274fce70c764aa988df5c3daecabac32e3e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/issy/file-finder/releases/download/0.4.0/file-finder-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7533e6f789da5b221cd9ee0c5eb80076d2417794101dc7efde7eb9c54b345920"
    end
    if Hardware::CPU.intel?
      url "https://github.com/issy/file-finder/releases/download/0.4.0/file-finder-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e17c509b838b5a22a48f0d51c99870193fa53fb31d8c744ce9bb78ab565bd6d5"
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
