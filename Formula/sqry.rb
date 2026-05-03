class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "12.0.3"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqry-macos-arm64"
        sha256 "40b298b3ee8de33ee6936ff9d79ad885965139167084f46155535a6bb1216347"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqry-mcp-macos-arm64"
        sha256 "7eee6a7cacfad477df5a95abc112c0dcd4af23b0d64507a81397d5cd4ff4e7e6"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqry-lsp-macos-arm64"
        sha256 "4ceef97abaf401ebaab2669a852cb670d971d91562725dfab15d1f404b692960"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqryd-macos-arm64"
        sha256 "9d9bf84436648b2111f7efa8cc539495910e32425f2b8ad08a7340993aab5a4f"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqry-macos-x86_64"
        sha256 "4b4ae2eef4844d89a815e473aedb3d305647c565745b9bab4b0ea04c5e482a85"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqry-mcp-macos-x86_64"
        sha256 "03ab97fbff3469bdc1b68c22020440db9bd45c4b57502ebf48f3249a44aaf001"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqry-lsp-macos-x86_64"
        sha256 "be1e171e45e243861c8eabc0cfe03f71a67ed3ac49c29f9c93088987fb59d381"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqryd-macos-x86_64"
        sha256 "8dd5f2875d3bd7c64f3003c19bf01be7e1769243e40cb5dcc52cd878f2946960"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqry-linux-x86_64"
        sha256 "a35797417de9d0ab5059447270b2c28fb7197f6b8220c7214c04b51f83bfdc53"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqry-mcp-linux-x86_64"
        sha256 "2e73ffc5eda8dd9e9b81df162af55cf9862a5c8a58062ed35bd698ed4ed26e1d"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqry-lsp-linux-x86_64"
        sha256 "3cbe4801ae99fee4c1dfec4e583d7d8e76230ee1a6abd7c05bac4cd88192fc65"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqryd-linux-x86_64"
        sha256 "0c2148a0ff5f82ead8d6a0df434970f40419b6f9397d6409efd38cb8589f90f2"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqry-linux-arm64"
        sha256 "1712272e9a809d69e28d5c027d9913936802fb94e76f6c2e379194d899928760"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqry-mcp-linux-arm64"
        sha256 "b924e554a91f5fee46ab33f5dc6eb67119b853e5f282074f74795440d5af3cd8"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqry-lsp-linux-arm64"
        sha256 "d9723ae17096c20bf788f086e84fac630cda4a56f85904cbee39278fdc1526f4"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v12.0.3/sqryd-linux-arm64"
        sha256 "ddf69c5a57b3e983e2ecf3504c87b62dcabec9622c858bc40f55812fbb2e7b98"
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
