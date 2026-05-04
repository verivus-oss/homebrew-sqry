class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "12.1.6"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqry-macos-arm64"
        sha256 "728cc182901bf83e17ed807fa0393f5a82480accf365a3dc7fc57b3d88335f69"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqry-mcp-macos-arm64"
        sha256 "fd89f962dbe12b2d3fd9b0dce743e2c10bdefcbd4b2905338645e1da3d74501d"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqry-lsp-macos-arm64"
        sha256 "7c1acf34591da463c12bdd044cb396ab3f18da266f7564d3acf80a74d40e6f2a"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqryd-macos-arm64"
        sha256 "9b0de5d6705ae43d4aed2d331a1463d100302a91e1a4081f40bd7f38d06cae31"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqry-macos-x86_64"
        sha256 "94491bebb68afb38159c7b34432e707d6ca124a7788cbd11e8a71bbf01539e49"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqry-mcp-macos-x86_64"
        sha256 "df548ff0f8ae579b63437e1d61dc076c1a6edde2b24b52e418d31c808c6d4ac0"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqry-lsp-macos-x86_64"
        sha256 "fbcba54035dd474fe323ce6540129ddeb90cc127f7dc5a9602077690448e8cdf"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqryd-macos-x86_64"
        sha256 "fc020401c88532a98470a33b63b906d7a4296bab1aadbac1a3114a4a87ad8bb1"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqry-linux-x86_64"
        sha256 "ff821742dd933eb0ceca58360979cab7772c8696eeea02a1a5a5edc8bbc43263"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqry-mcp-linux-x86_64"
        sha256 "beebf0796a173eee9e6b02f4fd1f024147faf0b3aead8360fcbb8c8d05b21da2"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqry-lsp-linux-x86_64"
        sha256 "3a1b2f1ea102520e1de7578f8198bbf468a979417af3effb95a4738b9bb4a21e"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqryd-linux-x86_64"
        sha256 "e8399b2cb6fa2cf2554666e98eba25870d4c47c3ccdfe13c6a1e42cf91f1f797"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqry-linux-arm64"
        sha256 "597d019145a01ca1fdb049f362b92c71efbbdf8e4a2a5bf2915a8ed15616450b"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqry-mcp-linux-arm64"
        sha256 "6022a8122d35e149d62b19a1c8f634bf063624c896d320fcec45fe2d6a13240b"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqry-lsp-linux-arm64"
        sha256 "29fabf6168152cf6e7a69e61098ad8ecbbb0d3d46c250ffd5fa3a239025d770e"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.6/sqryd-linux-arm64"
        sha256 "74cf39172609962ea7f35ab2d54ec07d2c5376215c1da93b934bf3a5cb6b2ab5"
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
