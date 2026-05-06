class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "13.0.3"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqry-macos-arm64"
        sha256 "da5d0b2cc37c8232ed278324d9cf0ea7b82d5a00421e9d0e19a79221aa1280e1"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqry-mcp-macos-arm64"
        sha256 "8f536539e6e18297552883110012e64a527c9ec9fce27a3528c9a1820c2107de"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqry-lsp-macos-arm64"
        sha256 "d123e5d1b686e6033e9cfeaf8b67dc143a97270ed47c75c47f790a5e900eeadc"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqryd-macos-arm64"
        sha256 "d0a138fd09e78fb76dc2837794388ee180d83c3e0178b01ce970743e938ea335"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqry-macos-x86_64"
        sha256 "0917b428c8dbd3d9b32e49e2d202317a268a890452e18ba95729f5adc78a8ddd"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqry-mcp-macos-x86_64"
        sha256 "82edba9061f56d66928f70166bb7412d1ad10ddcb4e349d0a4e515cff2e71022"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqry-lsp-macos-x86_64"
        sha256 "27fc747162bb1ea12e3155146f0a962b2646ca98743bfeb0e786d835beaa1f66"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqryd-macos-x86_64"
        sha256 "1f08cf335a63c2f53422d1a26f06f7b519df76a1942a81c068b7965560fd9818"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqry-linux-x86_64"
        sha256 "d14809155ba2475e1a2967e40031e2bf3dc69f3fba64450b6f5befe2f9457d9e"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqry-mcp-linux-x86_64"
        sha256 "4feebb9745fa8e37229532bfde9dbb775dfe13ddb3fe3be5be735ef72253977b"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqry-lsp-linux-x86_64"
        sha256 "42ef13b6559d2feaf71558854452e50546ea3ed5664d981e06dee82203d877bc"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqryd-linux-x86_64"
        sha256 "5f31a48dcea3ce73fbef0e38fdd361eb2455c638205dcbf28ec2f18aeb7528f2"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqry-linux-arm64"
        sha256 "f4b26061af5410915bb2c86c7fe45c4c209b8fd23acba421e96f33a8544388a6"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqry-mcp-linux-arm64"
        sha256 "396727304d9d4fd7b4099057f0bcaa915bfd4550d6efe9a323fd901cd2c767db"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqry-lsp-linux-arm64"
        sha256 "f53bb2c4d2260d87f5187da4e4145123750f21089c437a741ea0fa4a0a4ba82e"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.3/sqryd-linux-arm64"
        sha256 "dd7c37b721cb6c3e97c9053afba4f90af545ff44743b5c96780eac892d7b723f"
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
