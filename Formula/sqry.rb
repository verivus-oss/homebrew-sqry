class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "19.0.6"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqry-macos-arm64"
        sha256 "cf823119a904b717dbe7a73b910908391122c6665533a55189cc5777265d4dd6"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqry-mcp-macos-arm64"
        sha256 "e83e6646712b9c8ad7c77f32c366f2d36ea24198cf49c08d48e24beed0787c3f"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqry-lsp-macos-arm64"
        sha256 "0450464c76744d182a601165b194f6308bbae9ce13159b7637cf48ec59fe0061"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqryd-macos-arm64"
        sha256 "4fce0af62fa5bfb38af1c00d0484986b7a294c8218d9211f8201305ab3889b40"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqry-macos-x86_64"
        sha256 "ec6237527e3fe2c86431885b8610c63737b59fb517472d920b7e1ca8f37fb1e8"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqry-mcp-macos-x86_64"
        sha256 "4aada7a6c26fd6a815064ee856760894aa6971ea9959d2ed99d9a7c8aed760bf"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqry-lsp-macos-x86_64"
        sha256 "d55a63228e65cd2021100ac9a2071e837de507a91e2a4c95fbc7168806349c26"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqryd-macos-x86_64"
        sha256 "376d283ebcb7801b6e0937e622c181a861e1cfbd037925d95b39d579b7b7058f"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqry-linux-x86_64"
        sha256 "3de743677f7ccae2202465058c408d1c83a5723c73b57eaf4911e6c5c6827d1c"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqry-mcp-linux-x86_64"
        sha256 "39c0647ed6ef7ea5b8d1b61ab756669f68013054f9664d6ad3b679a3fcfc6cf4"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqry-lsp-linux-x86_64"
        sha256 "c7408611b95a7fd4d716692e98deb53eaf0eb77b847bc86f03c1039be61bf137"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqryd-linux-x86_64"
        sha256 "5994ac51bba99b17a1c21d1680ec99bac843d80e87f6fae28e95e85fba6e01a1"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqry-linux-arm64"
        sha256 "1910e3bfeb4fd09cf05aa828621d87f2b0efec60ebcad722d9d3617cec8b8e82"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqry-mcp-linux-arm64"
        sha256 "56c6f13a82afc2abb71e553208bf1e3d2ff1c9ad03754955d3da2e5214f84fa9"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqry-lsp-linux-arm64"
        sha256 "f61ac056acdaa06b038b00b0cf13879a1a354546cd9cfed34c30d605e7126946"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.6/sqryd-linux-arm64"
        sha256 "4c028599ad4a8a0ee4d2a29c781e33a775974f29950fe1bf20aab7dfaa41f3ce"
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
