class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "17.0.0"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqry-macos-arm64"
        sha256 "992995425b754188c2d7bb80a3b03cbc990af1ce41ebe5c2306d290cf4d64464"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqry-mcp-macos-arm64"
        sha256 "c008552d75aebf3f1bf73a080c93ee33979ca5ef9967421f16f4663d028c11a4"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqry-lsp-macos-arm64"
        sha256 "0729cb4c3a9e64a2523735f5ae9f3615d9a13f044f91148ab9cc21b05492190c"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqryd-macos-arm64"
        sha256 "8326ea29e95969224d285ff547cf269315e23189c8eab681d452b27cd91aaf12"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqry-macos-x86_64"
        sha256 "03e48c8405b21274846d224845c288f9e79add5055efcf500b4b829e2935d9e5"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqry-mcp-macos-x86_64"
        sha256 "3def2d842260e8c61747ac4d1e00a30fe5faa246ac0a0f7a2e8f48becc9dd7bf"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqry-lsp-macos-x86_64"
        sha256 "47ce8a61af582aca665952f690c59e417c7402c7c28af947a22a3fbf0cb8b1c5"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqryd-macos-x86_64"
        sha256 "0924d036fc86f4d4b3df63eca7652d875cc657367e55d9c9a2553290a2bd4472"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqry-linux-x86_64"
        sha256 "e2fae053fb932f30b2f734561d45b77380884a52fee12ced7b9f955b45c59149"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqry-mcp-linux-x86_64"
        sha256 "4dac5ab38846047d86b3a1e8f5b486bc90a15b1259811a0dcbddbfb5ddad58ff"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqry-lsp-linux-x86_64"
        sha256 "8968f0cf56734189f53b92c6759cf3486abee07f3f0ce214279b1a11df9ff95f"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqryd-linux-x86_64"
        sha256 "8d8d9bcfe3296d7a822ed7c08268c97ef72902669665120627111c2aaf661aa3"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqry-linux-arm64"
        sha256 "358ad7ac17420cea29d1abbe40a4b584f1d6bec0d9590e829f6aa08d753143fe"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqry-mcp-linux-arm64"
        sha256 "53c4e63727fd177549f0d59045caf261d5feb900a0f7684c62cf471643edf1c6"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqry-lsp-linux-arm64"
        sha256 "bb7b7da68c7ea08b274f61a23d3cd9694ef33c490250932fb9901a45e9ecbbfd"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.0/sqryd-linux-arm64"
        sha256 "295f52725c0cc05d46d01588f3d62536c7280dfa5c40b10446c98c2e0388be02"
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
