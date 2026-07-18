class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "29.0.5"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqry-macos-arm64"
        sha256 "b64dee195310eac89ec22907bb71e1a732a33b00e71b7dc25119ff84195e0a40"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqry-mcp-macos-arm64"
        sha256 "aefdbc6e3a9d6220b2fa0a9eedbba1cac665711465b816933a6a6b0c37b81625"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqry-lsp-macos-arm64"
        sha256 "56b4bbc4ff0d6e840c34853fd6c21ce617c109e8c4fde20aa4543b272e13da31"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqryd-macos-arm64"
        sha256 "c5485e20b685d24a36095e4b833d7256ae895d296dac879d58d6ccce612d0edd"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqry-macos-x86_64"
        sha256 "85eb1c546c11d7e12cfd9af2c52d750fde0e6fe0deb0454b5897866638a03d05"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqry-mcp-macos-x86_64"
        sha256 "920c1ba6cc4b9d61f57e41233917685343efd8b7d92a19c568b7d328870063eb"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqry-lsp-macos-x86_64"
        sha256 "49ed6d5b57728c53f2292d0a72ca1589efd71b413787704fd4106f4c117274a1"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqryd-macos-x86_64"
        sha256 "687b09eaf1b7832260ae9e79e7b75f93d2f5f81f8ed830029caba9d9123c636e"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqry-linux-x86_64"
        sha256 "24e65a628fc36b33ea195252bbde2b11a37e254106fa865b0774422bb1bd36b5"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqry-mcp-linux-x86_64"
        sha256 "82fcc70c063edc2a1ae5e40ac785431223c91c5069562d5906470fd17e76ffeb"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqry-lsp-linux-x86_64"
        sha256 "9a3c3f0dda3439ae67bd646075dafdd7496d5beaab0949f5242d7095a3d856e6"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqryd-linux-x86_64"
        sha256 "34b70bf27625d5ceaa18d846583961fe796fe31cb10e1ac256c7c8ca3f816b0e"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqry-linux-arm64"
        sha256 "8b5d2bbb27a0611b9d6539013d462fe9f3e9bbb5b8daaeff9e54442e311a056f"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqry-mcp-linux-arm64"
        sha256 "1b1760ce7776d48174ecfb9d9620d6b1761a62df622cd8813e5b6850ef7cbfab"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqry-lsp-linux-arm64"
        sha256 "a916d4a0ce4428fe8efbff715aaf218c4f7361f655f47fe1b2c0b5b58b12f74a"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.5/sqryd-linux-arm64"
        sha256 "1346c3093551d4aea7dba3fd29f48433c55d26d8c2fdca55cdc907812c1ccaa7"
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
