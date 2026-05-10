class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "14.0.3"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqry-macos-arm64"
        sha256 "95a4196bd83331c9d2d071b774a8a17494415be3006eb124fbccfbb21314004a"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqry-mcp-macos-arm64"
        sha256 "8dd08b92bcc760bce9428b1ecaa3c8d4776f3d09bd5f0a2cb56ab6d3dab12bc4"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqry-lsp-macos-arm64"
        sha256 "852eb1df0f5739b519cd824c848b629f7cc3e4dd470b980635555c807e7b286e"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqryd-macos-arm64"
        sha256 "1b0420b70fdffe62e3667ac55145f0ecd2adabb430fd4846f5ba9aff4d2dd461"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqry-macos-x86_64"
        sha256 "48b3773803118c5a2657e7157cc75cd0c1d2674c609ea49de89005178920865d"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqry-mcp-macos-x86_64"
        sha256 "7af6abe5158231471a106f60eb019f5117b746ebb16e45694fd74811b719e0ab"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqry-lsp-macos-x86_64"
        sha256 "a0a0ec9d6e5d05f7a99ce703931064e195dda7632ae5c24194cbfcf2851f391c"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqryd-macos-x86_64"
        sha256 "8d22a52f9f87df37d7dd38dfc3b2b5a06915f9fb9df2df60b16f60737146a338"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqry-linux-x86_64"
        sha256 "384830c0d4bb22bb7f5d004fa83cf5b68f76e8e2c1266c71413d5c352fa20c0f"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqry-mcp-linux-x86_64"
        sha256 "a6891aeb9cd528a7848f037dcf017ff90695491881a05574d6a126a725bd45f0"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqry-lsp-linux-x86_64"
        sha256 "bedd928913aafd733b33bc57a6e27412d66f91245d87d591e3f951953f9352ed"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqryd-linux-x86_64"
        sha256 "b8677c64fbef2dc7234a7b866f29061f86fc6cf18ee2f32ec9f7bdcab4fffd43"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqry-linux-arm64"
        sha256 "6a5f227421d80aa818c353b809db044b6992e1e0e694edb42849bec8a313859f"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqry-mcp-linux-arm64"
        sha256 "15348dc42e3762c2fa45657166ea62a6e1f6ce92005b58950f2a575eee5a0fa1"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqry-lsp-linux-arm64"
        sha256 "2e95750f81915e4ab8e59dea89db5a493d2a3fa4f76c0ea056475c4102c21168"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.3/sqryd-linux-arm64"
        sha256 "cac64271bada5d505dd7ec19b003b3135b1f799d0568a7e75e495466a5ef0d40"
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
