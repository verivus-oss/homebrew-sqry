class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "23.0.0"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqry-macos-arm64"
        sha256 "a8e3d3012af506171c81414e2cd54abe35632bf8666682d18ffc39e2ebc85ce4"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqry-mcp-macos-arm64"
        sha256 "997909497490542e01b1ea65c3d1bdb56b7a6139c4a1f67a0b79f3f3055fdad1"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqry-lsp-macos-arm64"
        sha256 "0e15f8a426d554e38f05446e7ebb31bde23697e5755a85ff5a00e2dcbb9d3eb2"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqryd-macos-arm64"
        sha256 "d1a204cf8232e3e45190e91d590bf28972c9482b55863a211af579f0f0dded5b"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqry-macos-x86_64"
        sha256 "bb422180e9e6b9c274ed711afa834aa8aaf95fe44b5e5e4e54fa114a2ecb07c0"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqry-mcp-macos-x86_64"
        sha256 "0acc68b26064ae1cff9f0d265e5ce8e35a18d0abe1d87e4a22e9974a46ff0897"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqry-lsp-macos-x86_64"
        sha256 "e102bcbfb2e575a651f28497346c07cc0bf8aa153ff3f2e6becbc0ff8046ab77"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqryd-macos-x86_64"
        sha256 "6edcf33f5944860edb3a2c76fcb6aa384bc40683619be9cac08b849fb9dafcda"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqry-linux-x86_64"
        sha256 "8cd4e33a1e96a7b24595a86b2e8c044bf19e0001c4367f1ef5c05375738c3818"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqry-mcp-linux-x86_64"
        sha256 "be4e6e5b6a55a858ee7f29c52bb0f5982d921d9a4d66e2cf259ab05092aaa7b7"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqry-lsp-linux-x86_64"
        sha256 "76018c725110f42ce2e345633186ac64718ddbbfae89b605ac691e3a82014c32"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqryd-linux-x86_64"
        sha256 "87db53cdd6a3d24eb0fd3ba2f1608807c4d7f011c07aa2efb17edd2939135b0b"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqry-linux-arm64"
        sha256 "842535d92b9140d66aa8df85cd585ee23cb03f492403786bac00332cfa4f02fe"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqry-mcp-linux-arm64"
        sha256 "b80058f87521aca7551e6d42e44ae25401760e41fa1335e177d4f520f66820bd"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqry-lsp-linux-arm64"
        sha256 "3b2f1139ff6ff3ecee33c68484e6c112e91918c89005e051ee1bfbc2ecb87a24"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.0/sqryd-linux-arm64"
        sha256 "77a5cc1653f3edafdff42ead2673f951de8cd13b59aef96022ae4063840b7228"
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
