class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "33.0.0"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqry-macos-arm64"
        sha256 "a667f199266c8a7e5b86638843a5d799653a945bc48a60fdb298c0a5c863d267"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqry-mcp-macos-arm64"
        sha256 "c7d775bf1266642edb1385fa9604eba0787e883cad6f3129de6660403617c12e"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqry-lsp-macos-arm64"
        sha256 "3fb5770d26c97cbf8601fb2c80f6cf67235f4ef747c1a91b0a2ecfe22cd06418"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqryd-macos-arm64"
        sha256 "9b9ab2829f3692926b767156b1809c258a66732af1803320885f28770b8eb7f9"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqry-macos-x86_64"
        sha256 "5ce32ebbdbb67a59b5234b4e0b29c7b5489599f164678853e5e31843579e819a"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqry-mcp-macos-x86_64"
        sha256 "97bd8339773af0ed246d78f0122dc6f9b3b8912dfe8482c6562fbabf3d25554b"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqry-lsp-macos-x86_64"
        sha256 "8ab81527843a61383ff4dab9229cd302926530967127f012c238e98ae250ffd4"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqryd-macos-x86_64"
        sha256 "63949bdebbb57360b87e1c1c4d556225227d76b85e460c597616e433656285b7"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqry-linux-x86_64"
        sha256 "e3f83dfbb7f6e83e86b64c4de6d1574713cc7e4fb6d9eac225c7ef467440b01d"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqry-mcp-linux-x86_64"
        sha256 "237d96c44041b87f51e90e4a2a85dbf9f029ad5f7a8cbe0f0fb17301545d5c3f"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqry-lsp-linux-x86_64"
        sha256 "b55228a0975db34d83a82c82795d48991d9b516f972abf0653a46616967f6529"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqryd-linux-x86_64"
        sha256 "a9693618aa38c13efb8d6ea6023731eb29a9459f98577558cb365db9c7145bf8"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqry-linux-arm64"
        sha256 "a88646ada2845f54ec9a0a744511f20a794528d6383c6301d104ed17381c8653"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqry-mcp-linux-arm64"
        sha256 "d87b9527a40bbeeac2d605d5c6cfd9748f3ebbe042277400fb82b6ce67fd8c2e"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqry-lsp-linux-arm64"
        sha256 "3739be21bb8b7ecdd63e3cd01a652a9d1cce2f51ce8a3b14bd402cfa74f3a620"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.0/sqryd-linux-arm64"
        sha256 "9ac8066833b72facf257c944fc6df01dba81f734d022af6008ccd626162b992a"
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
