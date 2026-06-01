class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "18.0.2"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqry-macos-arm64"
        sha256 "5abe38d359e39f2e9af339d0176ceb0910a04f2e619c6b50087b0f40af8bc8ee"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqry-mcp-macos-arm64"
        sha256 "874ff30f7903fa77fcffd0dc27d7f8544933fc4eb4d90ef0753e48b4a6ed18da"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqry-lsp-macos-arm64"
        sha256 "c30d6c2e1aafd59b250a8d17b97cce8544eaa164731fbc891a9c8ad8a612b046"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqryd-macos-arm64"
        sha256 "da4e52e946f5d1fe8645b08db43bb9232fbeece6863011dc5a8f09bf97e35ffd"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqry-macos-x86_64"
        sha256 "e174b0ff6a19d0ea8663327a5853683495d6457aabefa81de1123401caafc782"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqry-mcp-macos-x86_64"
        sha256 "f743c813d3c67ef347930ab5b17e870bb51c34b0de81b18d8d45e3984d1cc46b"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqry-lsp-macos-x86_64"
        sha256 "2f7e062dbfa0fa51677bf358bd8bb752bcc5c8f5458952bd806c953c0828f61e"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqryd-macos-x86_64"
        sha256 "1ede130cd364c6e70e3df06d252783ed668a4bf1d5db196078c69354f57ed90f"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqry-linux-x86_64"
        sha256 "1dcd507a63a481cf9c8dcfa8e09a05d46dc6f394efb552130fb078a59be016ff"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqry-mcp-linux-x86_64"
        sha256 "197858df63b3b186b61a285a3658114a75ef2700ae4169dc2921e7527f0b91df"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqry-lsp-linux-x86_64"
        sha256 "8529c9f2f1fbbfb191994cb9bfab6bf4b3a2d6e4b5797ba4e2afc8682d08ebf7"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqryd-linux-x86_64"
        sha256 "26126e948dc1eda9ed581601bed2c33cc0fdb659fbe8db8c222d546852218e76"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqry-linux-arm64"
        sha256 "5a3d4ff7121615a435c911808c44990e493c0a43fede7fbf7af55ca56de1e5f3"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqry-mcp-linux-arm64"
        sha256 "a47a9299770944c46beb42c60c8f39328f3638e1384fd6a4ed16c1c55806d8f7"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqry-lsp-linux-arm64"
        sha256 "7a5b57980adab9b9ad49cf5332badad738748649724def812a9c0eb6c1cef057"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.2/sqryd-linux-arm64"
        sha256 "8c02724735ffb9d8f17923bfad6e2fc06d27cca11869635e7d8a2ea4263552be"
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
