class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "13.0.0"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqry-macos-arm64"
        sha256 "5bd95d1dca439d9a079fc716a1e290454cb796e50f781b5c4a98802726575a70"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqry-mcp-macos-arm64"
        sha256 "554df77303facc26336760752f7f916ede12d06dce5e622964ad69d7e3be3cc8"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqry-lsp-macos-arm64"
        sha256 "c2d1fd2ba5577a1b7cf8fd8a06380145efb93d282ccffbca17eb078af39a7627"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqryd-macos-arm64"
        sha256 "3e8913d5a4736c78f9788a1f1fa069771ed0ce64359bca079498d396b9ca4d56"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqry-macos-x86_64"
        sha256 "acda02dd75038b2307866d2ba21636eef7719f7f1b799538ec31152f5dd5db4d"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqry-mcp-macos-x86_64"
        sha256 "d6866c9e7a51153de3de01098c7d48e7d07570a6a7b5a7c9d100e438c6f9de6e"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqry-lsp-macos-x86_64"
        sha256 "0d02b130c8e39ef2cc4f5e0f2ac15b803006e31bc9b20ed04ca46fda4cb05c35"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqryd-macos-x86_64"
        sha256 "d84f4d735a83405cd8afad8d2cdb9f306c6e16371690bdf519e09808ac97251e"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqry-linux-x86_64"
        sha256 "776b25e4d29c44b7f98f7cb547d7cba4faad6c9cf59b2fd3f94097ef0bba709f"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqry-mcp-linux-x86_64"
        sha256 "d6db78b10cae83ff2f2168a90a4ce5bca394999b2c975a1fa5ca154ffa276131"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqry-lsp-linux-x86_64"
        sha256 "09fcb1010e1b4383e0e15d6ffa906306d09dda280ba670d119f1835289a382f9"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqryd-linux-x86_64"
        sha256 "e0964754ed97023d0b3a6dc0c36f723f65a91e4191c71dbc0b2af3ba3c8ec73e"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqry-linux-arm64"
        sha256 "4793677fae2930e4e867f872c27eca9f7f9d8b470be375c2e0b33c5f981d2f4e"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqry-mcp-linux-arm64"
        sha256 "a9276712598b23a1b999678e453f6b283731491f66d104a9cf95703d3fc1ca1f"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqry-lsp-linux-arm64"
        sha256 "2438cb659976f0e9b1ac7a250331bafea038c9541af6f2bfeb57ef42667de8bd"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.0/sqryd-linux-arm64"
        sha256 "5ed86c6a8653c70a680e79c65482b8b3065b323ddbed0c99a8f0eed83b132a47"
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
