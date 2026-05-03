class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "12.1.2"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqry-macos-arm64"
        sha256 "53839314f778907b7efd429b27884899eec03f50a26621f46f3ada4012776e24"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqry-mcp-macos-arm64"
        sha256 "58c9f9ad70e6c6376182024a75e02b0b661f713910dd6e1d91355d3583d71989"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqry-lsp-macos-arm64"
        sha256 "c52a66c64c62789066ec87cdcc4739e0a47de4c118fec173b80438bcc23e214e"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqryd-macos-arm64"
        sha256 "7f2e41ae84c8c6e3585872135035c489894812e465092956d6c39a5783017186"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqry-macos-x86_64"
        sha256 "09a97902638cd3a4ad06164bdb921b7c51443d3c540743bf92d54d72e84b6ce1"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqry-mcp-macos-x86_64"
        sha256 "5ac1cc5a39bb216ed5fb7e2d9e3fb7d510cdbe354640d8a3ea4b490c918967a3"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqry-lsp-macos-x86_64"
        sha256 "4c5938b661a170d27184fb98b17ab7e3ebc8d1be30664077cd5eee98443e982a"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqryd-macos-x86_64"
        sha256 "ff749eebae1ec925f3cf351ce467fd33ce16ff7de45497c7e26775762d8b7e93"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqry-linux-x86_64"
        sha256 "cead23e8fb52784a58304cb1fdee8432263b44c9f7bfa7d0986adbc7876bac97"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqry-mcp-linux-x86_64"
        sha256 "9ec31a987c658e19825bbaf5d5c2579439a4b9c19f5bc00351ba47dc7da1d63e"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqry-lsp-linux-x86_64"
        sha256 "025fd73f99884f13b0f7a855d8e0da74583c74b91f6967e08ab922860792ffb6"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqryd-linux-x86_64"
        sha256 "ac35d0fe1c1531c51f847ea8815569989269b0eb7a3ad58515a1601b8700e55d"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqry-linux-arm64"
        sha256 "36333efcbd02f9068effd47628f06d19ee798a912da5bd22f53d8140d5f13407"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqry-mcp-linux-arm64"
        sha256 "fee2c430be56bcde7319b8b70441bd8302ddb32775e540fb8d7d5718610c9f65"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqry-lsp-linux-arm64"
        sha256 "8ee9d3ba120bc9c019cf45afb8708187404384ef0a82a695afeac4a27c428839"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.1.2/sqryd-linux-arm64"
        sha256 "44582c577935451e993fe6a03dbb189b21406ea7fd3fe1de924557902c1ce0bf"
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
