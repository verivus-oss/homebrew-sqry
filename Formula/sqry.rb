class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "13.0.1"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqry-macos-arm64"
        sha256 "774f5c002ce7339429e62a966cf95fc348aca46c69b16e0ce4e904403c889d2c"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqry-mcp-macos-arm64"
        sha256 "224b2bdd8dfc3cef8957d82c53777fc49e4e4749a24ca79b6ac20c693604f42b"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqry-lsp-macos-arm64"
        sha256 "e2fbd3c6169fbbe6e839e5aafd6224751d14e26e100c9a3e6ece65484232271e"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqryd-macos-arm64"
        sha256 "1ba0d83143740318327f2687865370aecb4198a16a617aa7c5f0ff4c346dc7fb"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqry-macos-x86_64"
        sha256 "c1e0be57a2fd28520a10a25fb40fd9f85a7e5eb6f2387fbdbf69ef0d84218981"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqry-mcp-macos-x86_64"
        sha256 "e7683e7740d49a03a90bd5928d29b8026dfe4cf8778f3cf34ec147855add9834"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqry-lsp-macos-x86_64"
        sha256 "83e980599ac79c2ade264e7653faabd550641b40a9aec500be0abd335b5fdef1"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqryd-macos-x86_64"
        sha256 "900f2615006d29cf031ddac43d76be9c662d76c9438a742a99e08cac4c00ed66"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqry-linux-x86_64"
        sha256 "d22993a9165f0be64ac1cec2a924f910e63a8ae693df436b92ce934921205100"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqry-mcp-linux-x86_64"
        sha256 "8c0a37014b1258bd752b573faf067ea1aeaec79bf5bfff3ae097cc746817369a"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqry-lsp-linux-x86_64"
        sha256 "66ee4aa6a8a5bacfd7b7803652f035f92ad2f879e83f3f7f3715a91e79751f30"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqryd-linux-x86_64"
        sha256 "6f7071ac1384d3410e02c7322d6aefe03e6502c896055b7fc26b76758ca97511"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqry-linux-arm64"
        sha256 "7f56f8eb10ba5f1cd2a410d1fafeafd198bd979f5c3b25ecb50f520b17fcd24f"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqry-mcp-linux-arm64"
        sha256 "f08518345eeae28094d620efe0556d7ce2ba0224016f1630f42e1761e94bb608"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqry-lsp-linux-arm64"
        sha256 "23c7fd0297d15adefbf41ffc07e879ce3c55a6900ca359606c7e8006d3ae5d83"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.1/sqryd-linux-arm64"
        sha256 "b4aec0f098040671ad4961d1cccaec927fa89c3959e05b6d79b80484b80c1d28"
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
