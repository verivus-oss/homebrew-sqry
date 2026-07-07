class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "28.0.0"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqry-macos-arm64"
        sha256 "0c9cfaaa59671bf1ff26323d175d5f002dde90c31cb60c384d20864adf09f679"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqry-mcp-macos-arm64"
        sha256 "ebf622ef42bd01a774f12a12a5980c576648aaf7d1c9c9509a87b6fee2c67e17"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqry-lsp-macos-arm64"
        sha256 "37bba3bc8acb7f109fb95b62b1cf26db5ca8022cfae1450869b1bf15b124fe64"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqryd-macos-arm64"
        sha256 "4777bff66f22ae4e281014386060219f1d196dc5515fb64d9c2855bfed13b9b1"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqry-macos-x86_64"
        sha256 "f6034336e9a874266d88c8785834dcd03256bbe89a67269d5b455a2c412fe732"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqry-mcp-macos-x86_64"
        sha256 "5978ac410206a4a2541e4dbf84be9aaa53f1e476be64cc82fdcc696fe1006e79"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqry-lsp-macos-x86_64"
        sha256 "f735bfffd7bcf168f8af01b9d4278f3c200083f5612c261b44e6ac00f2c26762"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqryd-macos-x86_64"
        sha256 "db2975c6818345fd04efdab56ae9f42a7cd964ec58ab3a1abe0cb06fa7cdf71d"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqry-linux-x86_64"
        sha256 "b552ad74dd183c2e76a3e6758fe0936c6ee1952aa1895a0199456b1ad70851ce"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqry-mcp-linux-x86_64"
        sha256 "ab8901537e07b8b1a3354300e7f32e184f542dfdb8b6c1e806ce620871068507"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqry-lsp-linux-x86_64"
        sha256 "122856ab20ca6e1715aa136f9efb0a30993258ea2b774fd369fdf34352b71acf"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqryd-linux-x86_64"
        sha256 "e5dfe70b85a027d00eec5117d51cc84387dab2c4c9695d58f5613ccef2f36b59"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqry-linux-arm64"
        sha256 "48d8826716edb965ed4493121d399a591d4bd5232acabbbb5aaf550507ab6f2c"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqry-mcp-linux-arm64"
        sha256 "adb2337255a7618f84218eacb275bf24b6c5865009b721bcbbdae407c8db10d5"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqry-lsp-linux-arm64"
        sha256 "b144c9a1c4d910b300adaaa285f34da2cffdd36b2f470fd342e9a9f672cbae8a"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.0/sqryd-linux-arm64"
        sha256 "5c7948b4b479095ce00ea4da0f2cdbf687b21e0482d91f1b2443ccfad9982e78"
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
