class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "17.0.1"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqry-macos-arm64"
        sha256 "14e43e756f8af066b52bb6a732a6de6c0083a64cf8e46dbb89726a2812e69314"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqry-mcp-macos-arm64"
        sha256 "0dfed0e47662125bfe25539249bd3cf025907c1bef1eb2c18677f2f61155d091"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqry-lsp-macos-arm64"
        sha256 "b79377255cfb065eafe0110625decac8d3494512fe7602ea3c3d5a845a80098b"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqryd-macos-arm64"
        sha256 "fa70987b695729037d9f2e33fc2ac396d6a1a406d43d3845fd268def8bbe775e"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqry-macos-x86_64"
        sha256 "4eea499602870bb2080a52ffe4fd1fadfaaea3fa7c854e895ef62ccf3b87a523"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqry-mcp-macos-x86_64"
        sha256 "4e3100137feba97c1d995aaba8b8a7cb31fc4e56deb003be4b44cc7edd813c32"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqry-lsp-macos-x86_64"
        sha256 "e492c74b7338e73baab2e82359c764787730c8a1bd355b00dd8448d9c4302139"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqryd-macos-x86_64"
        sha256 "e3101fc785f03add64ebbd27dd76cf70c0156f4713569802351289f99e353dbc"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqry-linux-x86_64"
        sha256 "d5f5630397f8264a4eb5ba06aeb5316ab6bd64b27f66f26d24d558f96e2b4858"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqry-mcp-linux-x86_64"
        sha256 "4e5ae6c0fc2386c946077c7915af478309d4b9b8be0932369b01600b72749bd6"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqry-lsp-linux-x86_64"
        sha256 "1c19fbf7a91bcdb224d535406ebc082789d7e182dace8b9a7f1306a336368380"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqryd-linux-x86_64"
        sha256 "db08cae61f5243e75cbd1f8af563e61c6a61bb3b057eab356d94be80b1066575"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqry-linux-arm64"
        sha256 "ff2d4662f8f70f2d7a06c4d5cb50f2ce544bd996b559baf32047f653ecca33a5"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqry-mcp-linux-arm64"
        sha256 "8a00fcc0e3fde1e376d41a561cc36fccc52a744d09a2dc651d07dc3f7b6fcf8a"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqry-lsp-linux-arm64"
        sha256 "82ca6bd29974271621be2931eb0ce5d31d8f2cde3838dbf94a996441551ced7b"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v17.0.1/sqryd-linux-arm64"
        sha256 "ef192ec07a19d4d6205abc663d14b6e184e101a1173ed7d55d04da508d264c06"
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
