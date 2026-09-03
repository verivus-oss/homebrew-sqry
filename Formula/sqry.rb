class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "31.0.0"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqry-macos-arm64"
        sha256 "9c3893d3f55163f82f1831448344a34a70ae03c518681ac0d7acbcceb5ec020c"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqry-mcp-macos-arm64"
        sha256 "708be05a9a8b7dfeb49d405c6623ddd13337cc958eab2e52c2e968d0a5531e1b"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqry-lsp-macos-arm64"
        sha256 "48f5634c1f1659c6a186d7720bb08d0ebeb5f8064332b61c988f61862797e24a"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqryd-macos-arm64"
        sha256 "3067cdde580f1bfffa3d23e37431e1a6f878dd23dc2cf57a2b1895712d7c72d6"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqry-macos-x86_64"
        sha256 "fe0210d9a23cfee8593f11849cce2bed2a328deeb2fb0281beaaa11930c0de37"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqry-mcp-macos-x86_64"
        sha256 "b7683034e315696c741388fe605908bad01bd54bbea8d0b8fe58f21d9c30f7c7"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqry-lsp-macos-x86_64"
        sha256 "3ac27e8d91b9db22c4803021b1797ccda182b2faf94777cdac66ebd42760a34d"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqryd-macos-x86_64"
        sha256 "fb4b292037b6dcab6173013d037650140ca7188f7237f1baa0f1ba52f805a6ec"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqry-linux-x86_64"
        sha256 "0ebfe4df57e3eacafcf93c8d28c10a93698c489dc3f278aca0b4609dd38b7d3a"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqry-mcp-linux-x86_64"
        sha256 "23918e57409795e0e3822a4ccecedf9fc0acc4c8b988adcfcb49f37af40d7a52"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqry-lsp-linux-x86_64"
        sha256 "48e4c1b89e58a563838bddff8d97fd11124c7b6a2cd730dc029662158f31d5a8"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqryd-linux-x86_64"
        sha256 "15922298f0efb94e402e86f0b864f9856fbde8c14d1fc7abd6119792a4de514f"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqry-linux-arm64"
        sha256 "6f1309f92127bda34493272f54e777aa0db9bba4f283b1bac1dd65f3551a47ce"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqry-mcp-linux-arm64"
        sha256 "ff368a9c3101cd05a536aa324af9cd3742b3eb4a040d6d2b9ca74533dee297f1"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqry-lsp-linux-arm64"
        sha256 "c2c938349fd97d5a340092dcbb75cfaf8e4a51a0b30dbd1ab06ef806a8c18ea3"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v31.0.0/sqryd-linux-arm64"
        sha256 "a4eb3eee195f60dd0bda4d7f841df536cee59d04c1fda3a6f7877018426fb9be"
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
