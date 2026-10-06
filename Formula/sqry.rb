class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "33.0.1"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqry-macos-arm64"
        sha256 "bc6217969fb50d0bd24dd18c3fe194eda8e28f11d980d5b6c0409323c290aac1"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqry-mcp-macos-arm64"
        sha256 "d49473a90cbe47be20cfe03f64718febeefcbdf3921a8818314fd83ab97896b9"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqry-lsp-macos-arm64"
        sha256 "617cbcb36415a42cbd1cb1ed242b666defa4bd05b8500d446fcd4702b04cdf67"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqryd-macos-arm64"
        sha256 "d1611a61b576a7c3b0da1a043516d5c2de3d25758fdfa5b9106300e5b6e3d540"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqry-macos-x86_64"
        sha256 "4fb8087a8f1cf560160811e958b5cca1baa8276213fbcf6324b8483c9e530d29"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqry-mcp-macos-x86_64"
        sha256 "ef062efbf7abad32011e0a81d841330154aebf3e71c57ba3e353deea7da778cf"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqry-lsp-macos-x86_64"
        sha256 "24a11000237279129dfc68b0f0b56c2d4f6355da52327e4e755026781b7c7dd7"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqryd-macos-x86_64"
        sha256 "e8e510fa79a7673f7bad66b5b822f53de763cc50ef4bb4992d8ffb35b7dc99e9"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqry-linux-x86_64"
        sha256 "49054b1f50dc926f57c621a7fbac798f3676be12d5c5200496e273b8fe1daafb"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqry-mcp-linux-x86_64"
        sha256 "ec658d289d5f44dd60279ec8eb6cce3584d03ad10fea025b5077a265bc085ee8"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqry-lsp-linux-x86_64"
        sha256 "2ac7408eef9b35d0292ce79056e5b9b6bbed42bf98d65dc2ec35d034d46cfd78"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqryd-linux-x86_64"
        sha256 "3f35a09a5da22a6a1580ec3ff6edd4c0270427e9e1223216ce9e3175631de5db"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqry-linux-arm64"
        sha256 "e8d560f6c576bcb6bf5d3820351b41636eadc7a3e3b1d161072c88afa9fe3478"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqry-mcp-linux-arm64"
        sha256 "6c330e694cca2f15e6f0d7e5faa89be838c0f468361c61fd0faa5c5c4db5775c"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqry-lsp-linux-arm64"
        sha256 "274e06603481e1994517c7689d1b79f69f2008f27afe7aad3d9cda83f0b8c34d"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v33.0.1/sqryd-linux-arm64"
        sha256 "fb34022fde8618f1ebfb1d7539e0c45e5d0504cd99e1a691bd33597546d64925"
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
