class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "29.0.2"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqry-macos-arm64"
        sha256 "a759afb3ccd62653fa27988944f74a55edaeb93ef0918a7df3b4f0d47c866bde"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqry-mcp-macos-arm64"
        sha256 "51062fcb7b65dc9092352af66c6ed7aa85e5a85b2e7c932e5879adfc805ca518"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqry-lsp-macos-arm64"
        sha256 "5e04d2eccbf8f73b1388a3f2b50da200a66aad14c14b03fd77c6fa0ac5ddf0b7"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqryd-macos-arm64"
        sha256 "c4fdbcb96cbafab97cebc4a5016285224a0632cb5d9e9cfb1c216cc2efdc2793"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqry-macos-x86_64"
        sha256 "00d410f896800b5fd44423c1aea83a8638ddedba81f31af6b0e17a6e277177ef"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqry-mcp-macos-x86_64"
        sha256 "6ae0262071b7dd4077c97f9d5ade56f1e96e9884f0d2fbc4c660e9624a040fb7"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqry-lsp-macos-x86_64"
        sha256 "5ba9c501249dc1f6e70b38726217fdbf77a15c322627f8e186abfeb8c2b88d69"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqryd-macos-x86_64"
        sha256 "2f58a7dfe574a90b14263329e3c88ad614cb4169d3167d6c56f0efe8f1e2456f"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqry-linux-x86_64"
        sha256 "66b1d34fa456a3a58e1f5f9ee7416668f974ce1b138407c1a68577e1387d6a5a"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqry-mcp-linux-x86_64"
        sha256 "c89add6528edb47902177bed35f05fcec0cce192b3332f8395e4fdf4a3b49865"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqry-lsp-linux-x86_64"
        sha256 "fb7ed1233ca782dcef124da3d4f10dcb2b8c903102e5a1c79701e7ebd923effd"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqryd-linux-x86_64"
        sha256 "07b6be50affa9dcbb05c17d99252cac171e128aa41434a30bfa9ae5fee9afde3"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqry-linux-arm64"
        sha256 "c4fc455950bebadfe61ff9969f5ad0f50b3b4c3741aa683eeb70fd2df84d04a7"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqry-mcp-linux-arm64"
        sha256 "95cecae1b4c2a17755d34db6765d31671252bfbc99e290ad18f42fda3410d29a"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqry-lsp-linux-arm64"
        sha256 "8955bb135733d8dbf04dd601a9536d10c65bb749ea30c0197c3435ea29a857e1"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.2/sqryd-linux-arm64"
        sha256 "b699f368731334911ae1fe8ad2f72563e252112c1de1507fb0856a50a56eaa37"
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
