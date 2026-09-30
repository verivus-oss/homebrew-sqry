class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "32.0.1"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqry-macos-arm64"
        sha256 "b3c059cd1e49cb2c2690fe85679fd4ae195376ec2839058bc2303b9d8b78eba9"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqry-mcp-macos-arm64"
        sha256 "def314e63dce67925fa1ad2733b09de19fcbee77b24cad97cdf1c073ef2a9e36"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqry-lsp-macos-arm64"
        sha256 "6d23248222d70f29304003067cf0a7fc0dab12082815bcbe1d16a18adf739854"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqryd-macos-arm64"
        sha256 "e2d9d5d07cf405fa422d2b6c277ff2a0fefd3a3cb1cdfc7343784fcd7ea9b342"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqry-macos-x86_64"
        sha256 "ef7341290fadca294259c1fe1b62324422ca94ae5b3360d6b20aae1916f93ae3"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqry-mcp-macos-x86_64"
        sha256 "3fda37f37329246e06f0df301276d3d533a3ef094abac92e0c04d8e57d32d0f9"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqry-lsp-macos-x86_64"
        sha256 "9480a44b01a8235e19e7f196df0703ec61b6c136e830dd6459f16669e910ceec"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqryd-macos-x86_64"
        sha256 "e8a5f1dafa523f523e099ab160ba971d3cbf8916fd98e50affc76f58a1530e08"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqry-linux-x86_64"
        sha256 "8b6a9026e8367286c2a5dea016b110070a86f1c0a74c15bcf56a2f11ce31a417"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqry-mcp-linux-x86_64"
        sha256 "75114c066f46610c2b1ca6fd9e8df46997ee8407e3ebcfdb35938e6f50f00f0b"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqry-lsp-linux-x86_64"
        sha256 "1d491c5456e7b91390ecb829bb6f4ea5df7ef811331fe25467c57912de7c87d5"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqryd-linux-x86_64"
        sha256 "a75b0e771e997c7a10938e5ba063e26563b3dbfa05fd5d6d2affc2c5d11ed90a"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqry-linux-arm64"
        sha256 "18c8a9c92ad34a45aaa63d50d93a4361e13ef6de1c17a25cd9ec2ecd4585a35f"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqry-mcp-linux-arm64"
        sha256 "a77adf1933e73d74cc4e7289f214382837f961c9ed19414740ec21e0e0dd51ed"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqry-lsp-linux-arm64"
        sha256 "c41f1a64920aa3c0436590cd1f53b4b278ee20ec83f9eb5b54299c2fa68a55f9"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v32.0.1/sqryd-linux-arm64"
        sha256 "e80aac28c92e38aa999229312485eca6b15c0bf6160b8d8b7b52cd4666aee411"
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
