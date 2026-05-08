class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "13.0.11"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqry-macos-arm64"
        sha256 "210126b7c355bb04bcf8bc408fddd5c3cbd06e0cbbdae67c8c5a5e5870342984"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqry-mcp-macos-arm64"
        sha256 "0adda409561c83a4d11fbbcf090350140aafbd91735303d7b09e8fcaaa1f865d"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqry-lsp-macos-arm64"
        sha256 "93208dcd8c9d4cb50f611b0d18dd3245f95c75f4d65cadd85cafe22249f03405"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqryd-macos-arm64"
        sha256 "05b588c8ba3ad8037019355c8f2740ff205c2b2a436526f8580e1e5f482c3231"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqry-macos-x86_64"
        sha256 "28781c9776573902dcad477aa8ae5d30672d4e3b045e2bc2a92a88e70fa76aac"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqry-mcp-macos-x86_64"
        sha256 "618281aa03fa4ace0f1ac561f26e27b0970eb4e8194b37e7ee78d529e70ed6cf"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqry-lsp-macos-x86_64"
        sha256 "0c373d5a3a659c1db55aa7d44ff4400a2c625060b5ed4001782da27cb3acb804"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqryd-macos-x86_64"
        sha256 "b0f7ed2cf6045510e58bf61778c1b3da43c3a7e06fc3ed78ac0e5eb637f734eb"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqry-linux-x86_64"
        sha256 "7b4a9a20a8f64415a0b7f5a248648f676ad3c9c9fdda32d9d5c6c383ccff07ec"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqry-mcp-linux-x86_64"
        sha256 "aebeddae6575afc5d6c51dd66739c70479564753c2689f0e0413df85160dd937"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqry-lsp-linux-x86_64"
        sha256 "9413d60b92b787077b8dd87b07adb394330a59ee70a0b2087f4f58b816f7d05d"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqryd-linux-x86_64"
        sha256 "5b0cd81e2c55ae0be781f023cb6a866737bc15384d2c1b2427a91e2921f76225"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqry-linux-arm64"
        sha256 "fc45be0f31ecac9b8a322a844912ecb723c64f5dadfb967e8d2f30911499c1fc"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqry-mcp-linux-arm64"
        sha256 "03656c9c6fbe21014934906cff9f6018f25dadc0e9cd86ed9592a7ebe96c88ed"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqry-lsp-linux-arm64"
        sha256 "6f2d6306d34c11de608ba9b736bacd019f065f745af709602c4470acd492425d"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.11/sqryd-linux-arm64"
        sha256 "cc73f6c52ab1e129d43729091e0e43376ee646613656d4dac42e145c271c81ed"
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
