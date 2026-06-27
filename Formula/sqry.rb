class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "23.1.0"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqry-macos-arm64"
        sha256 "d37634443d2ab78e9ad136884891d6a40219246ecd9fa4f50614caf84fbe8d28"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqry-mcp-macos-arm64"
        sha256 "4bb9774fc18688ab8b9ed8339a687172a311767fe404ac1642dd296408825f0e"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqry-lsp-macos-arm64"
        sha256 "0473e6895614a7907de3ad6e6d4a3fe848ee8810fd57caf3e826ead06e998824"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqryd-macos-arm64"
        sha256 "a68e769c001a5459c04571ddf2404f25c45ae6e87ed289c5ce1815067d373a0e"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqry-macos-x86_64"
        sha256 "77580b533c1733a06264c57a70cd21bd1c9fee7e938a2f672a47125390429890"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqry-mcp-macos-x86_64"
        sha256 "ee45010fa2ee8ad03ead7ec39d3f14ad4d90a96f99d669c00b387ca1039a9acb"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqry-lsp-macos-x86_64"
        sha256 "0c6a72f360594420f2b907cc059d6541d7e99cadb01d1ec30994cb5b56f402b0"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqryd-macos-x86_64"
        sha256 "9450b25c1d0e0cc8ef474c6b0f93fc72fffff91255bd41fa018efcf79e5b16ff"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqry-linux-x86_64"
        sha256 "5e8319982ec373df0429897bdd1a87f4953eff754093d7b6d7287201a5b12e29"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqry-mcp-linux-x86_64"
        sha256 "d1bbac83696610afd4f4d6fc6b4ededfaa58e49c5ac72a6eb57af7aff0a50fa4"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqry-lsp-linux-x86_64"
        sha256 "d3e9338636cb1cb75ac65a43e15dc740c5596991e44f60c2a8e699f8993d2b2b"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqryd-linux-x86_64"
        sha256 "7aa5e29856f19b8db92f69de3d88bdc50012834b8c69ba94ad5f461a7be86820"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqry-linux-arm64"
        sha256 "d2624b8ff4e1ee457341117dfc6b09af01dcbb9df8acb4034a313841a1ddf67d"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqry-mcp-linux-arm64"
        sha256 "58c57314308fff78343246c6b0f75f7483ab356b46b6d95fa7c7083f77474680"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqry-lsp-linux-arm64"
        sha256 "f729612cb6c65ee240243e4e0292a2e6bec6350c50ff4287bc8ca6ee221dd1dd"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.1.0/sqryd-linux-arm64"
        sha256 "c1014cfcb60ecf4caabd212b2736c0487917f6a26f897cd7ed0de8287926aa3f"
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
