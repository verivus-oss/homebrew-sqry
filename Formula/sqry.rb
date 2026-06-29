class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "24.0.1"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqry-macos-arm64"
        sha256 "b71c0c23ca083eed393b03e4668c6fff2b56acebb590e6cc3ae776c42bbba3fb"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqry-mcp-macos-arm64"
        sha256 "a32c3c381b8d02f4f0a950571bbecf2c83c634384b6e0f54f6ce2465aac5df4c"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqry-lsp-macos-arm64"
        sha256 "909b169dc1a897c5bb5a48812f6a03c3b896a31197f309d91f29d858102ce5d8"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqryd-macos-arm64"
        sha256 "cf4f712750ce3afcfd28bf23d29828f78abb8681e86f2f828d1091d2090de076"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqry-macos-x86_64"
        sha256 "cd3c435793aa838efb63da25767fa0afeb8b0d6e250e3905af3ec555b84aa766"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqry-mcp-macos-x86_64"
        sha256 "e16131b1b0045956b47212f232b9afbf468363148d42a0b7aecf36f688df59fd"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqry-lsp-macos-x86_64"
        sha256 "fe97d267d7535bae2448d56cde6190c0acd3ea419886f2ddacb6cf1e1c285a62"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqryd-macos-x86_64"
        sha256 "35d7662d5701c0850ea44b0c27a348ab5f03245cbe36b971751591adc95f5bb8"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqry-linux-x86_64"
        sha256 "a43a881af853a0525f3fa3990b18b5a1ea2f4bdf62b77790ab0ca58ddf32c17f"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqry-mcp-linux-x86_64"
        sha256 "ce35f41c7db64e6f73b26193bc2b7ec763317e15658238d834d5f2c4e5406b36"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqry-lsp-linux-x86_64"
        sha256 "c5009c57787d55f55631722aa276782c08c2ddfc9f5d8a822ce2e282619d63c9"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqryd-linux-x86_64"
        sha256 "8a0c0ff3d618b644aab12800e92ff338a72f1dc35319a9e5ea60f7ed84187a0b"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqry-linux-arm64"
        sha256 "8fc6d554bd08d4fb48e21d324530b13fa893de4915f8a8759364faf4da768a60"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqry-mcp-linux-arm64"
        sha256 "b0b3f2737b544e9843a1bcd991ef912a8d2cf200dd1c46e0a0551312300ef87e"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqry-lsp-linux-arm64"
        sha256 "3a88cbb9b1ecc5707023a1f66c4586f6fd62000e7ffae6fcad5f36c43ed63fa4"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v24.0.1/sqryd-linux-arm64"
        sha256 "b0f22978499ef8235c6e47a6431a46ea01eb65688377405efd9f6ded843d5ff9"
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
