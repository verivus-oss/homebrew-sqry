class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "18.0.8"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqry-macos-arm64"
        sha256 "09f85c508df516248527bf94c64009da147f34d2a138086361a1005ce523ebc3"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqry-mcp-macos-arm64"
        sha256 "e0d9643c90a32b076c471d287a1de438fd0c8371da30fb12a98159a420da3403"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqry-lsp-macos-arm64"
        sha256 "badd4a9034bab48dc5f7862e8906b3b43c7c8b60f76897e35147639b131d1e2a"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqryd-macos-arm64"
        sha256 "93057c21701b3988b1402d3adc6fb7dd5e04cebf465ffa91edb33c5c465df3c3"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqry-macos-x86_64"
        sha256 "8369aece50dd71e9fb49395b1a53070f10b1634440316a2f7ecdee2460820f20"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqry-mcp-macos-x86_64"
        sha256 "cf9e0f8916e1fdb628e22f3f0c269869560be88075e19ff77ee5eec87f153d33"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqry-lsp-macos-x86_64"
        sha256 "1fe3cd99fd0916d09a508f8fec0273a2036fb94eeaa3d5833f70dc8915589145"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqryd-macos-x86_64"
        sha256 "8a7703e375e653b1dbcc564d526de27d56d5037462f4199dcd66308940a2f412"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqry-linux-x86_64"
        sha256 "969fbf2930f30be0fc43c5a1e9c051635c6560bc548dfab8b4d7917ea4edbc00"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqry-mcp-linux-x86_64"
        sha256 "38a9033d5220f3b3dbb44c0256cb4bbf6413d077a51b62f90d3cee6ebd480fe8"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqry-lsp-linux-x86_64"
        sha256 "e3a36406f39096f996865dc6c489a18735b6070b45af86f90b5db0dbd0f3d0ae"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqryd-linux-x86_64"
        sha256 "031eaef9a381aed7c762e962466ba4d8f0cce2d3d8e6ae2a71492c22d6afba6c"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqry-linux-arm64"
        sha256 "15de3841620763be83e9b28882beda659f45e6e364f1424fe5b20f44704ac417"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqry-mcp-linux-arm64"
        sha256 "433159839802b88b9ac8295989f83a6e9b3a4c3555ceeb094c4c2622c43bb0a1"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqry-lsp-linux-arm64"
        sha256 "adc208bf997a6eebaacaf23732502a2da9b1f342c1595c82a1f90d568bfa886f"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.8/sqryd-linux-arm64"
        sha256 "a3d564a82186bb5f6f1310c1fde9233ab80783c5cbc28c4a9e69b5bf38281d3b"
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
