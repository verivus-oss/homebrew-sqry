class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "19.0.9"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqry-macos-arm64"
        sha256 "e6d602cb735be843e518951f48c134ad07c3c67c01d66f854828a2666d32f50e"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqry-mcp-macos-arm64"
        sha256 "64d2178d6a400d4e331614670df28d1a026f8ec5665a7f4e752ded6a1815ac9e"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqry-lsp-macos-arm64"
        sha256 "5516623396882379a26531033b5f59d82ee620cffdd640379cb3d44cd1780cd4"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqryd-macos-arm64"
        sha256 "a2df077cd973d0669ec85560b1ba976febc307536876ec37c236a2f77b07e96e"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqry-macos-x86_64"
        sha256 "a59277d87c0ad5a99ba79003e76bae1221f1beb4abea4e4307a010ce87c18fbe"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqry-mcp-macos-x86_64"
        sha256 "2162caf3362b997e88d197ed85b4d9b1789e142be077fe37a4d9d98ec933f2c3"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqry-lsp-macos-x86_64"
        sha256 "04fe788b24b29249e9181adf8aea446a2c169da82917f0056b63aef17cc701cd"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqryd-macos-x86_64"
        sha256 "1b61f7d9f51900e745db6505107b5f94e4636ddede5e2ed8dfc0fd472cef032c"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqry-linux-x86_64"
        sha256 "8c558e7964408bec4994b7b45e58573a9f318dedc02cd1dc88acbf818ebeafd9"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqry-mcp-linux-x86_64"
        sha256 "c5fe7a324885c5305aa22d31e49288489507d1d90d345cc614a6aaa0a90b99bf"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqry-lsp-linux-x86_64"
        sha256 "fb77532ee375ced2b5c7e4ff611f220f6921463b1fe8c2364cb23caaebc29e21"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqryd-linux-x86_64"
        sha256 "e71c5e4f6fb230715f90bbd1a4b0fd90c645460ac117bf9b6e0541ecfb744c86"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqry-linux-arm64"
        sha256 "0e01bd9ac0e774837be3903850fdc19297b5ffa04ba74995ea3279b3d9439e5b"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqry-mcp-linux-arm64"
        sha256 "7990c8a0b2d521380eac4da544a99e75abd7494ab2c632e77636a2051079c63f"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqry-lsp-linux-arm64"
        sha256 "fbe8bf7579e08e579d34af588342bdd41cba759b69f90cfed4ef1e18d02d7532"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.9/sqryd-linux-arm64"
        sha256 "e42b7bcc3904ebf25f1235242999625c24ddb4a15f640b1b8fa8d2dab0118bbb"
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
