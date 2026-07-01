class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "26.0.1"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqry-macos-arm64"
        sha256 "c93a4cc5f9d561c0f1c683f0b1b11b421ec9e4cef7e25cba51a7c974b8e4e040"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqry-mcp-macos-arm64"
        sha256 "0b2b63d4e743e7fc50b065acf000a384c94defa80986ead5394e28001ee9632f"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqry-lsp-macos-arm64"
        sha256 "c89bc2f5d1720927c5a5b5342634ab4f4fcd62020a1a36893036ebe728407986"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqryd-macos-arm64"
        sha256 "bcc561976af778aebe7c845d53c8c57027cfcab38f844ab8b5dad323c512b1fb"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqry-macos-x86_64"
        sha256 "182d1fef19318ec57954b37a9453c7fba73822b41b24e2ffff8c23aa4485cc8f"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqry-mcp-macos-x86_64"
        sha256 "f2d9eb32899dbb97da3aad045557b2bb8e3e8cd350301bc23cb712b3650c130b"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqry-lsp-macos-x86_64"
        sha256 "3567a81213740978060170adba26f8db00058a3c90b8f3855cb1a3cf928e309d"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqryd-macos-x86_64"
        sha256 "d53d061179e9b5819f38a54bd7b7b66cdfd40b37292d8f057fd641fd1dde11d4"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqry-linux-x86_64"
        sha256 "6ffc996a9d7fb6fea76c98e3a68604e823f918d6222c06da98ef4b3946acf49b"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqry-mcp-linux-x86_64"
        sha256 "78eccc4558d31560af057f9d8ab8b51f06989b6e77ff63ece7a3641551b1e11d"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqry-lsp-linux-x86_64"
        sha256 "9e52c6733453878c7fed9301064a7682c070bfc3d2e853e5cec1ba3b39b62c5e"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqryd-linux-x86_64"
        sha256 "6a71352209aff9aa4135de27de3108acaf3c399e0e7ede3b9102e5c546431396"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqry-linux-arm64"
        sha256 "6ffc792f92381558c34cfc6dae20bdb07c0aed424abc161d9d1417250de3f91d"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqry-mcp-linux-arm64"
        sha256 "32c147cece8e9cccacce8bffaa9192984246ef938565d10529c1dcaecb3e1f3d"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqry-lsp-linux-arm64"
        sha256 "b8db759f4d7a87bfaa2d2b12c6a0ea4119c8a7c98a0a7d6694da8d4f6a2aef6b"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v26.0.1/sqryd-linux-arm64"
        sha256 "0bb3091fa23d8d3f72cbf1117539bb10628ffcce7c364e5b48bebfdaa9fa01ab"
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
