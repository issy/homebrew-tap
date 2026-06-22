class FileFinder < Formula
  desc "CLI to find files in a directory tree based on various criteria"
  homepage "https://github.com/issy/file-finder"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/issy/file-finder/releases/download/0.4.2/file-finder-aarch64-apple-darwin.tar.xz"
      sha256 "ccf99e93a753a46746a4627c037ed708f7c0c2abe4f8c065431c7554b2c5f5a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/issy/file-finder/releases/download/0.4.2/file-finder-x86_64-apple-darwin.tar.xz"
      sha256 "4a3a1280a6a79361535d62420ecad7548b8afbbe5b7e5d3c4fc701b017be0b86"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/issy/file-finder/releases/download/0.4.2/file-finder-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bfd0d7236dbeba49fc75e54a8af93da7cde73539fca77ff27d0f838775c9add6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/issy/file-finder/releases/download/0.4.2/file-finder-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0365dcc65bc013a421f4ad7bc1387857978046a24103554fdde154fcd5c5d979"
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
