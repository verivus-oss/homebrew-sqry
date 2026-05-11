class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "15.0.1"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqry-macos-arm64"
        sha256 "d9fb265edd255c9db39ea3f6ab20abe75b2194228b33aa987d061a1ae7ec6e55"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqry-mcp-macos-arm64"
        sha256 "fb447029e3405b7edfbd995feb1cfaf9687be678f9beee8e8c15431236fb37b2"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqry-lsp-macos-arm64"
        sha256 "c570d0eaea750a3b8c9d628710343e1f12e0b71d5e43d0ee1768f7b275ee06a3"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqryd-macos-arm64"
        sha256 "1a2823c153943924ef710ac5e5f6ce3dee57d4ed94b6d64ee8c4c2404b07a863"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqry-macos-x86_64"
        sha256 "a242bd813a8b72b77956c8a7f497614c52961ca05de17934636b08925dae6b73"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqry-mcp-macos-x86_64"
        sha256 "c0c22e4c83ef112937338f80e0e26ab60026f52d90fc1637924f06fae6b5c6ae"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqry-lsp-macos-x86_64"
        sha256 "dee04517e55fe680d332a05734167de3401360d0b61c5fde3a85490e962904e1"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqryd-macos-x86_64"
        sha256 "8d9fdb92d9ee05b6e8cec788a990fb8f3a3db1295913cf3a1d7b6fa6738a3a6a"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqry-linux-x86_64"
        sha256 "5c7f1dc699bff002f9f3cbde731126a99313d2f1d245f9c82a6a7bb14e435e9f"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqry-mcp-linux-x86_64"
        sha256 "2bc8ea1840e13370df4b1e039252b3d5e1bd48607c0017157d98f0243c6ef3de"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqry-lsp-linux-x86_64"
        sha256 "6e70e4e36ec37e635d9c143d1bbb5aa132eadd2906c02591a9c8b0f7731208b0"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqryd-linux-x86_64"
        sha256 "9a1e80aa99b2dd9e78c16a32a42a6794b9da7d4b8ad16b6b9d1678dc88413096"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqry-linux-arm64"
        sha256 "96a65fd099666bbc694359ae1865607cecfaf32c4c76a145c4e9f86bc90a0461"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqry-mcp-linux-arm64"
        sha256 "308fea6bd36e6d271dc0f7d93b0509c84acbe360980ee826f8a4180ef0abc8d1"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqry-lsp-linux-arm64"
        sha256 "ed46d9e780fe754632cbebaf6a99c22a6df3518499d766bf4a6f302566a88efb"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.1/sqryd-linux-arm64"
        sha256 "dafce15897e31b324be8f8c870bce7cf630756e734db0f1382e7ebd79c9b4dfb"
      end
    end
  end

  def install
    if build.head?
      # HEAD build: compile from source via cargo workspace.
      system "cargo", "install", "--locked", "--path", "sqry-cli", "--root", prefix
      system "cargo", "install", "--locked", "--path", "sqry-mcp", "--root", prefix
      system "cargo", "install", "--locked", "--path", "sqry-lsp", "--root", prefix
      system "cargo", "install", "--locked", "--path", "sqry-daemon", "--root", prefix
    else
      ["sqry", "sqry-mcp", "sqry-lsp", "sqryd"].each do |name|
        resource(name).stage do
          bin_file = Dir["*"].first
          chmod 0o755, bin_file
          bin.install bin_file => name
        end
      end
    end
  end

  def caveats
    <<~EOS
      Installed binaries: sqry, sqry-mcp, sqry-lsp, sqryd.

      Quick start:
        sqry index .            # index the current workspace
        sqry search "query"     # semantic search
        sqryd start             # start the workspace-aware daemon

      Documentation: https://sqry.dev
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqry --version")
  end
end
