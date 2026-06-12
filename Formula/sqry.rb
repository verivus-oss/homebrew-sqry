class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "20.0.5"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqry-macos-arm64"
        sha256 "8dbc8c9c3336c41b32523ef9b63e7fb32cda762f41445543d16a9c4bb1dfb33f"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqry-mcp-macos-arm64"
        sha256 "37cde4db3b8f7372a6960dd7fc9fae629812d707669d09a52ab8f3415f14c448"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqry-lsp-macos-arm64"
        sha256 "2c5a4f39d1545442498d5da264991ea9f6627d3fb1988710fba6cfb245fe3c3c"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqryd-macos-arm64"
        sha256 "dc25365c3dc76128a109a69ad37e2c8f0137aa35be209a11f8022e197059d918"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqry-macos-x86_64"
        sha256 "f79550f5e3de65e90cb0636ed0390aece6a2cc70efa95b3e9c3d2d5091176b2f"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqry-mcp-macos-x86_64"
        sha256 "322d04453d64f9ef588c73ea21852646495f07d2c6412bdce3772920a7be242a"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqry-lsp-macos-x86_64"
        sha256 "f329b591da58a0638fbea42e7333a45b6af0fe3d1821e3029c00ba19efee9b18"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqryd-macos-x86_64"
        sha256 "b04e186c8074cf680471b33d20fd5c4739b65eef0bee5f638dd9293a0b9dc2a4"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqry-linux-x86_64"
        sha256 "6e079fc06fa79f099d04e366101d458574745e1329a28933204c1f7c5022af88"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqry-mcp-linux-x86_64"
        sha256 "1976f142fcde0c55dd6a409fa2b684b46d8e6623758130cf3557fc773b735ba9"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqry-lsp-linux-x86_64"
        sha256 "34e597f728a406debd1fd6f8f61ff733b37c91952bdcba425fffdbff46e70747"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqryd-linux-x86_64"
        sha256 "ce4cda1dbcc870d1c500f2dfbb2c6dcd38ba77c3ba21965af435fd0dc27773e8"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqry-linux-arm64"
        sha256 "2454f6c56916692aa1ac400dd68d382f98091cb966880540d9085fce2b53a38f"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqry-mcp-linux-arm64"
        sha256 "6b8b092d9d59061c4f85965cc378425e215d1e9a06719c505eae7a94a659cf56"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqry-lsp-linux-arm64"
        sha256 "664adc050d1a025a3152f2f910cf9661fbd2e5f7fd5f576f536fa635e0a8875b"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v20.0.5/sqryd-linux-arm64"
        sha256 "bd118541ff9a3485254315bd5e3dbe819039e49b5fee318c6bd17981ff930de8"
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
