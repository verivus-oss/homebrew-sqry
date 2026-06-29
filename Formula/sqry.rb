class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "23.2.0"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqry-macos-arm64"
        sha256 "5eaed3869b46eb3917d27f62d8524ebeb92a410308e80d393526bea2463f4f7e"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqry-mcp-macos-arm64"
        sha256 "d22815075c01deaac4e8964911e827142e08c3cd0ecc57638686a4d087b1abb0"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqry-lsp-macos-arm64"
        sha256 "ca2c940231cfcd0322a8fd79fac381f13371995ac4f6eb9ac52dae509c1f2485"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqryd-macos-arm64"
        sha256 "c09aae00a4855006e3814e6ac4950d47b6ab8f002c57471dc7017d91628e3cb0"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqry-macos-x86_64"
        sha256 "7aaaabf6e4bc540b9b40f6b6f2df0bdce08c0d09c69bc7e05ac89d7bc842a1d5"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqry-mcp-macos-x86_64"
        sha256 "9a589af089b1ce08ad2a63473b05e2d49724e22f5bb2f2e0142c66567720a442"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqry-lsp-macos-x86_64"
        sha256 "e9ea6a1691972b80ab3e0e946a2ebc8bd5cd820799dc01d1cf66631e11320901"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqryd-macos-x86_64"
        sha256 "875589d1fb4d03b299d426b1508e87f3ca8d88e10fcf252bff7cce37dfbb22af"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqry-linux-x86_64"
        sha256 "67ae98a3177aa08e86dcefd0d9a133a0532f8fd3ed813d7ba9126989b429a476"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqry-mcp-linux-x86_64"
        sha256 "f9e3985e2dbbbef522bd8b2b20bfb6a402a187140b0afe41c8348a21612a2497"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqry-lsp-linux-x86_64"
        sha256 "0618dfbefd4a1d04e5ca52b42347573149ed1c8bf5c4c6e0f5481e1e3052ab28"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqryd-linux-x86_64"
        sha256 "3e29dffcc4a27ce08aa9ea0cb1252cccf55219e03bfc25c157619e6e63c92fdb"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqry-linux-arm64"
        sha256 "ccca384e4a7b12e29dac313bd72413f2ab5a9fa3d277b2e18564209c9749c0ca"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqry-mcp-linux-arm64"
        sha256 "d78cc0dab4c2dcbb90dee15ffae71a9dc83ebd3bdf6eba5e35ae89b7fbf42b65"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqry-lsp-linux-arm64"
        sha256 "6f917920b950fded5ef982e6ada3612f317d39bd46560ceaf93fa6a174867583"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.2.0/sqryd-linux-arm64"
        sha256 "9279cf8e3ebbe7b6959f8ffedd38616673f61ca2a84472a52c2c18d0eaf43169"
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
