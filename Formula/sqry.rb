class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "25.0.2"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqry-macos-arm64"
        sha256 "d7471d54157b01221fa1a5f7fa6fca23b3d0aac79bd83957b642614949906f31"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqry-mcp-macos-arm64"
        sha256 "56bcb2aa1df77971267e23f9b2e964c92d67c99ee7743c281d3168d4e935703f"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqry-lsp-macos-arm64"
        sha256 "f804702d1ad764c074958e9b50e43d400a53b127468db070d8de0b985f5b5b19"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqryd-macos-arm64"
        sha256 "91307539c2cb55b386d06279d7cd157a5a27a2376d678fdae1da8b436ffd9d42"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqry-macos-x86_64"
        sha256 "3ef74a4aafca05d2248547faae0af1a9ce8e2310e1d0faf77563cdd8d4205afb"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqry-mcp-macos-x86_64"
        sha256 "44059dc48b36f7a0d224cd6558eead9cb8aa06de57e114437d869bc787e9a798"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqry-lsp-macos-x86_64"
        sha256 "4207fcb5c69a75e9cf3ac3e66abe72ce8b68fed30d8741af0ccbee3e003685da"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqryd-macos-x86_64"
        sha256 "0b839dca12d9fba9cbb460861322c30a02327dd04c8dd6331dd78b602f6a6780"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqry-linux-x86_64"
        sha256 "3034e088825ea44cfb1fb5fedb376b5b019ae23a6f33544fc966716e1e3d2d97"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqry-mcp-linux-x86_64"
        sha256 "f5739c46c52a7c4be436d51ee539265c50b181b33125712e2f4dbf9e7325948f"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqry-lsp-linux-x86_64"
        sha256 "b0dc221351c084ffa6618ba333bdfe2b4e5ad0469a076edd29c2a2c823bdeda7"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqryd-linux-x86_64"
        sha256 "fb1a17fcf78ffd7b365972b6026a65e46c76ccd724c7e7d20ca29b4c665e5eb3"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqry-linux-arm64"
        sha256 "9101ede96259dc3d6cc686fd1eaf1bdda5cf79e668b971e2855751097f996dc1"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqry-mcp-linux-arm64"
        sha256 "7f55c378619e62828587e36d9022d4dbb81a5fd39c124e766db60bf6a56187b4"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqry-lsp-linux-arm64"
        sha256 "c4376995da8296169838803a3eb40bebd360c45b199d4b23eaf050f9f46010c8"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v25.0.2/sqryd-linux-arm64"
        sha256 "88e7ce9cbb479a5d93c0e8d82ae9304f71594c3f71117f39c0c991046f9e62ce"
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
