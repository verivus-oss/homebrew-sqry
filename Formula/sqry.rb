class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "27.0.5"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqry-macos-arm64"
        sha256 "b6c4d148e64acf23dacea0fc09f02fee0438430b5f0ae96f2003bc9c4bc8aca8"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqry-mcp-macos-arm64"
        sha256 "697ed359739dc9b80f84106ee8e19578d0104204cda405132a87c336ff516a1e"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqry-lsp-macos-arm64"
        sha256 "2932d7f7864fd0078cde38b1834328556c10c7ea4eb5913e43c17a9881827a15"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqryd-macos-arm64"
        sha256 "8ef91db7f5f80d58d892848a5b5f893fea11f79119ecaf473690fa1cdd3c468a"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqry-macos-x86_64"
        sha256 "bcbeab558cd13ff46d220c88bda790d9dabd315f06c720f2f0c866cc3d4678c1"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqry-mcp-macos-x86_64"
        sha256 "c5cb8f822b315eb6f9442efb058a3b68b705f12f708fc2fb6c108ae0662fa1e3"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqry-lsp-macos-x86_64"
        sha256 "7c1ff46b57600719bf4dea3ebad5f526b6ed2409e26831276fcec261f712b5f6"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqryd-macos-x86_64"
        sha256 "0ab6221e5bb65355d27bfd47412f2c9f18d88d226d3a2de75b6feb3f888a717d"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqry-linux-x86_64"
        sha256 "720de6a5884c84edb956757fc46f7f5cdeed16a8eb403e320253192d4e62793d"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqry-mcp-linux-x86_64"
        sha256 "e24c373b6dbcf38c57df1a942e02e88eec7b83928d5b0c12726523ff5e671a55"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqry-lsp-linux-x86_64"
        sha256 "9ca56d829c419842b2d98dfdef2bb78566639a159d9fb449fdb99b8d50a65a06"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqryd-linux-x86_64"
        sha256 "4d252eb7aa4d8a89dd416c5752619ac5e4042b5457cbb0e28d22eb4f0f7b4803"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqry-linux-arm64"
        sha256 "5d35d3d28c382cf2d55286c80505434f1bfa2497fb7ea972af7538bad49e2948"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqry-mcp-linux-arm64"
        sha256 "6590af094b149ff1c7a5388718047c59f7b91f06550d10ec06eed142946c314b"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqry-lsp-linux-arm64"
        sha256 "e21926e185f49f6458e96d7561fe28788825154350ad453ffe786fb866067670"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.5/sqryd-linux-arm64"
        sha256 "a9c3ec91ae37be9b53238ed19366fe5ed2c3644047bedcbe7de34cf2b29d43ef"
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
