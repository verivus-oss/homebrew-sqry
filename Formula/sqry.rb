class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "14.0.4"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqry-macos-arm64"
        sha256 "cbfecfd81241a6e8d0287e568284eb89d53647b29b87eb44ba4be867aab50f8d"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqry-mcp-macos-arm64"
        sha256 "eb4352d707ada88ad4c1bf1de00b2e32b8800d46c30bced65e1b7efbf6843501"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqry-lsp-macos-arm64"
        sha256 "ce95886328d5a0284643c11e9cff2ac84c71306a36cd11e16d5e0b60a81a90a9"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqryd-macos-arm64"
        sha256 "3aacb51066b2c6428ec4d4c09ae1e279079675ea866db7fc7f5f7af23a7b750c"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqry-macos-x86_64"
        sha256 "3b8cd983590b4d6559376b7d25eac649b4d52be85bdb98033c5da6ef10840aeb"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqry-mcp-macos-x86_64"
        sha256 "50c22c4180816fb636ffae2b5c61733e2d9ed4e187f7b1976779c3629857616a"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqry-lsp-macos-x86_64"
        sha256 "f0bf9b863a4d6944e6990389ebc2fac2b9f2dd21b9fcd7c24d3caf1c2251370d"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqryd-macos-x86_64"
        sha256 "6246bdf2e582109305e4aaa0194a34d4dfc8204c1495bbfd12a1425764702ada"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqry-linux-x86_64"
        sha256 "0b9d4a9ab3efbaee5dc59a5950bf552d6cff71fd7a824ea0d5f24944262fc784"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqry-mcp-linux-x86_64"
        sha256 "75cc1af895630de9c9c98a204821237acb6eaf01b5f53ea4fd949f89d9b4cbcb"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqry-lsp-linux-x86_64"
        sha256 "b1b8334d8971a520a19a8c08e768f8a26abe2a71c502dc6e8e41cf7511f5d591"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqryd-linux-x86_64"
        sha256 "d8c18d89902cf189014dc4e564bc65dda97bdc39b8da292a213817ecf8d88387"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqry-linux-arm64"
        sha256 "a584cb982ae5b0aacb248e0373e3c3c779203ee16319c97a4a4ab5a24556da00"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqry-mcp-linux-arm64"
        sha256 "38e8b8bb7b6bc8da0c10b1627b766368881cb0d503748eb42a53ffeb44cf540d"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqry-lsp-linux-arm64"
        sha256 "3f994d5e414bae02689b0e61713e70193c4621a752031f2f2fbd5d0e66d23a7a"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v14.0.4/sqryd-linux-arm64"
        sha256 "ba4bbb857476bb73297a36250c3a02f7a52245408519b45493c36316f9ff0d9b"
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
