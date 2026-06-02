class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "18.0.5"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqry-macos-arm64"
        sha256 "70c7c5132f8f621c2fafca8e88439bd0bd79d107fafbc866b46fd90487042483"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqry-mcp-macos-arm64"
        sha256 "ca2604123426b231a5361cfa49084b600096ec5273b9d2e89255f6b36264913f"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqry-lsp-macos-arm64"
        sha256 "17cceb76ae252e78ef907c8021872ddb238f75d28fe8b5b4eb4d4d64351c98b9"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqryd-macos-arm64"
        sha256 "51226a0758e28f58c927d281a6d00913588fb62d93ab62a07533e6aaa2a4d2f2"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqry-macos-x86_64"
        sha256 "57fd82d6451f853f61ec934c09c3ea4275bd6d5607ffb8679ce88b0615370fe8"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqry-mcp-macos-x86_64"
        sha256 "a58c130752a12e88901b9b19b9a24a2bfcc20db6af4d6f45ded0fb6b9ffcb053"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqry-lsp-macos-x86_64"
        sha256 "246d868a9eed3c0b5fc464c58f5cbab160daf85db5a38eebbdb0a62a5f185e40"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqryd-macos-x86_64"
        sha256 "1361ca188740182eb9867cf87dc2f180d1262a53d53c747f16ae559cef8f5d26"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqry-linux-x86_64"
        sha256 "b41372f7b28de14c166f2356f196660a03b3c1c35359e4e0e86424b7b42fc3e8"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqry-mcp-linux-x86_64"
        sha256 "f1a295d2813aa2c7e3ab75293f63670b201ef90686f8011dd64e384087d14c77"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqry-lsp-linux-x86_64"
        sha256 "01432c698a3a31369c56802c947d8fe9b7f069dc2ca412e4fa48f13a258910c1"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqryd-linux-x86_64"
        sha256 "6fe00cf6af0d0e7e8c43b943d6b1df7e9a09da12754feddc324b8e4057f4d404"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqry-linux-arm64"
        sha256 "2ac1df1cf7765ad8553bfb4b84109de4997e8a8eeffe3f3e89e7dd24570f9599"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqry-mcp-linux-arm64"
        sha256 "81a3282dac21b6c450f7009f86913410b81de741958071723ce0a8a1645e9a35"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqry-lsp-linux-arm64"
        sha256 "d53b4c9bd0f6500a63f1aa60f05473b477c7ca3f2280ac95589f943f78793a0f"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.5/sqryd-linux-arm64"
        sha256 "6b4c3e4bc2a38b8f16ab9366745c1cb08343d54a51dd411e9798a26af00368d6"
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
