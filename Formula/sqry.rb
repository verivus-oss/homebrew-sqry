class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "19.0.7"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqry-macos-arm64"
        sha256 "10c87ecea006c641273b5e8e77b3fe07f8132f4f7440d6a71205e04e26549b0b"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqry-mcp-macos-arm64"
        sha256 "31a1894cb4add11f927609a26cb1645e20e0c560869654ceb91793d1dcfb28e1"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqry-lsp-macos-arm64"
        sha256 "23286ce352958801a5b2585819a01c71ec4121c0aa57beb8f3cc37769a42d8a4"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqryd-macos-arm64"
        sha256 "66a491a6b60066b01b361cf62e62ea7a7bcf3ed595bf234809a9016818bf4962"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqry-macos-x86_64"
        sha256 "71abbc3293f154e08c6bbe990e5533d7f48b6d94d6ace1a71844a445d3fcf8e8"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqry-mcp-macos-x86_64"
        sha256 "36185be0a145a3f927098efbdb9a3e965ec1d6b736cf88325c3a0aa2c64e5c12"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqry-lsp-macos-x86_64"
        sha256 "d8ed77b8d963250dc87b30ec52b7d956dc0af7b52674ee7f0bf77371516837d2"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqryd-macos-x86_64"
        sha256 "f5f8fb22af818db4cd7f3656f292cd1213ce9cda8c97c5879fd98aec310ce272"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqry-linux-x86_64"
        sha256 "7b9d64acc2e9cb7b58fed532540490f906685605ee2de0af4961c6e878c2bbfe"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqry-mcp-linux-x86_64"
        sha256 "9fec0690fe4d201208a8e6ce332b8e45378394afdfcb01307b5b5d4de79fdab5"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqry-lsp-linux-x86_64"
        sha256 "88aa42ab7f199ca4cf57eb676ef54de29d3fd873ec4f9b3009a7c66479726fc4"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqryd-linux-x86_64"
        sha256 "79ab19bb1c81dc9c4f4661074a55ab2e36e7dce49d2fbf48125355ae621291bf"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqry-linux-arm64"
        sha256 "f5a1b0f25998e6897256b6ec5322c0f3876411e33c044cefdf0a0160c8cd2da9"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqry-mcp-linux-arm64"
        sha256 "498003393458cf452a3638dda4cfd36fc8cc21bc0d40bec1b1ece58d45b01cb1"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqry-lsp-linux-arm64"
        sha256 "3f564b807f328dbd4deb4e6f8340f26d02e0e5cefdd78f67632c8a4bb7346d71"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.7/sqryd-linux-arm64"
        sha256 "f2de4d3f197c3379e33ffd6fd197073fbbf112faa2f8f4bc780cd3d8eb872cdd"
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
