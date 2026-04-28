class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "10.0.1"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqry-macos-arm64"
        sha256 "04abc9747d925a8f1532a8483bf4b49d306ef5d6224d80fe13b9385e4dfb7ede"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqry-mcp-macos-arm64"
        sha256 "ee81b143c9369c8079cb421f033a8ce17f6a54e2c62986428a715bfb38f19b80"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqry-lsp-macos-arm64"
        sha256 "155466562626d16579a7d867236aa877a7fdfacd5e97e1222f22adeab68b4034"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqryd-macos-arm64"
        sha256 "acc6f3848a01b1ffbd26ab2446fe51497a79c6c35a9694e3b7bc2fa5d140addb"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqry-macos-x86_64"
        sha256 "f10a759bbbf14e4627c7789305f302efd72ee13547aa250bd2a2aca6184c87d5"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqry-mcp-macos-x86_64"
        sha256 "e4aa53e4d64836ccdda76d1b729d9f77578f83ba813f6f1d84e66518fb5c7c2c"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqry-lsp-macos-x86_64"
        sha256 "4b6d7d08bf107310ab909d571101b83ffe547af268f081f7602df49bc28b97e2"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqryd-macos-x86_64"
        sha256 "bf1fcdcfd27325c0fb4c0bb132784228fe6ded3ca1e406dc6136453e149c847e"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqry-linux-x86_64"
        sha256 "daee66ab84e06cb218d68ceec1ce47634db2b3902172aed455212bbe11530b0c"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqry-mcp-linux-x86_64"
        sha256 "ffecb7ea81ec7af69690550f5245f236274a4d27d0f0a5a161d129a0f3750d48"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqry-lsp-linux-x86_64"
        sha256 "0a25f8152007c20bc160121b304d9416dc03deca72c98ba60101fbbcd6bf80ee"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqryd-linux-x86_64"
        sha256 "151831df1409d52e281713a6086d54c93b07963f085ae658d6f342aa48c13086"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqry-linux-arm64"
        sha256 "817006138d0fd9dc4718b33656fe66c6589749facf48479466afaa56aa7b38a9"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqry-mcp-linux-arm64"
        sha256 "341a0c249bd090b754465362f60d21fb93cfc5d62b13254285a7996c8973e5c0"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqry-lsp-linux-arm64"
        sha256 "841d6aabd5c457e57077c5aada57ff6922006fafb97dfe85614df0b183a11a01"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v10.0.1/sqryd-linux-arm64"
        sha256 "8aa2fdd160d17d1ebfd4496de6ce2b2ebf665bc6752f559b8027c68cbfdbbbdf"
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
    output = shell_output("#{bin}/sqry --version")
    assert_match version.to_s, output
    assert_match version.to_s, shell_output("#{bin}/sqry-mcp --version")
    assert_match version.to_s, shell_output("#{bin}/sqry-lsp --version")
    assert_match version.to_s, shell_output("#{bin}/sqryd --version")
  end
end
