class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "9.0.23"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqry-macos-arm64"
        sha256 "60e8efa1d41d77c1ff234918d3bf7d9abab57be12d9eec4a0a475750959fc585"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqry-mcp-macos-arm64"
        sha256 "1a61158179d2a4b850137005bffc8518e5d617ecd288bc114d801c5ea1667e0f"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqry-lsp-macos-arm64"
        sha256 "43c5fbff2c98f4928d1e905911b8949bb7b16b36382ce3ce7c1ec57bccc91659"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqryd-macos-arm64"
        sha256 "0659581a21bfcf4b4f436936d7792815acd9999c3b7ac6a2de7f89e42f0a634a"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqry-macos-x86_64"
        sha256 "d8bc0b31d0a1a8aea36a785be900dc69a3c0154098b685c6c1f3805e0792588b"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqry-mcp-macos-x86_64"
        sha256 "46a7ed09eb0b3539a34f065df799ce5d4ae88f0c7cdec38cc88b32cac3809deb"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqry-lsp-macos-x86_64"
        sha256 "d88a72e6cb754cbdbe62e2e5f8da5918a28680da9c9bf46fbdfee4470e4d34cd"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqryd-macos-x86_64"
        sha256 "1ade2ab426fc7216b64186757988c5af118d48dc806a78d124086faad8898d0b"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqry-linux-x86_64"
        sha256 "1422e98f59fc080aa76824ba8cec4c04b62dfc9163390c8d42a518569e6bb3eb"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqry-mcp-linux-x86_64"
        sha256 "3108e546633f53f0d488a2f180011c43bc5e7bc35880360bd46b6562531cf280"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqry-lsp-linux-x86_64"
        sha256 "09b0edd94d834b88cc97229ebe2ba270b9b00bf151b32ade25258eb1dcb0af4a"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqryd-linux-x86_64"
        sha256 "762c4b3ee9f717c93cbe7a70beaf4bd434cda9ae958fd4dd6bf7fceaf7b7bcee"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqry-linux-arm64"
        sha256 "8d417b7545882aea9901f6dbcd71f5f821355a6eda0b4b7eb35cc8395c7de094"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqry-mcp-linux-arm64"
        sha256 "0d79c6451aef7a6935d78c3998f27b6f525e2792dadce2d43e504af5ac2c02cb"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqry-lsp-linux-arm64"
        sha256 "4a0a331ceca5ff1e7e2db3df4b179ea2666cb8d5645fb0757cbcf54e9fd9a948"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v9.0.23/sqryd-linux-arm64"
        sha256 "a2347fd07e3d0a528eb4b157f3d97b3a24dda830d018f3fc82cc3cb10e32d060"
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
