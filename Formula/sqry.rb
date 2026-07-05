class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "27.0.8"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqry-macos-arm64"
        sha256 "c3c17d66bf4ddf589ac8483d87bb7fa5fdb58430eef46c771275c64672561679"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqry-mcp-macos-arm64"
        sha256 "8f2b49f69efaeb2aad0ed6f306e12c82c2c84c2e40aa4587a95cbc46795a35f9"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqry-lsp-macos-arm64"
        sha256 "94e36875c16d3e815b20ae1b6b5efb4edef251f2db04b5b0b90e2ae5b7fd6f58"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqryd-macos-arm64"
        sha256 "135b9c1323053fc9a981af4e2a3b1109424b1dd7862b1f50c6e3e24f3e2061f0"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqry-macos-x86_64"
        sha256 "9ac7a6d6ac59f1cd8b8cdf64ca6802b4d4a83b90da6d1ea7974a848b7b661416"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqry-mcp-macos-x86_64"
        sha256 "c7a03b08c29954b2c11b863f1c18d7858fe7954aff6bfecfa39d37264ddbc097"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqry-lsp-macos-x86_64"
        sha256 "083636bfa024455194d7d07e5013dd759e3248b5941f6f9d3a047f10ef8314a7"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqryd-macos-x86_64"
        sha256 "7059757c4f28d7c1d0331740433f88c7cfd59b8a8b44eabe7d2bbc7498eca513"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqry-linux-x86_64"
        sha256 "0292da22005d6293808aebb11f2a19b7070439215339d67dd5f678c43050f006"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqry-mcp-linux-x86_64"
        sha256 "198c76c3796943f5e630fa5fe736c2cad34cbb1d7ea504fc6669aba2eeff17af"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqry-lsp-linux-x86_64"
        sha256 "455653f778aa141f2bfba937bf07c83e511ebf2e3ef4df90ea5458ac552734ad"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqryd-linux-x86_64"
        sha256 "2270c3f17de986820d1af3e4391d54af280fb88876e523b897e8d33003542578"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqry-linux-arm64"
        sha256 "3c123737635cc4b65c193c01f2ec24ead0fcee7aca62475d9ff479438812b689"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqry-mcp-linux-arm64"
        sha256 "419b740ab1bc3a8f059140975b38fd9f8997a2a9211b6e54ca2fe34584b9c09c"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqry-lsp-linux-arm64"
        sha256 "1faa5263c9ad90e44589504bfb69245ffb795a7e85473be5f0eb8b15f6a3c3fa"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.8/sqryd-linux-arm64"
        sha256 "01bb65d46b3ca761143a393368760b118b86e849ae5977ca562364bcf373355e"
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
