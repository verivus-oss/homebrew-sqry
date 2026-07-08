class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "28.0.1"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqry-macos-arm64"
        sha256 "714917f496a536b1e71df2a5922c27b77b06bdd9fd5afc383c8f6ac16fdb8f71"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqry-mcp-macos-arm64"
        sha256 "0a0924a1d7eaf01762fc92a98635d8c181039684eb0bb03a851020f5af4e70b3"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqry-lsp-macos-arm64"
        sha256 "cf69f401afb50710206dce8d51c0d5ab6ff0d64cfa3098243fb04733abcf1768"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqryd-macos-arm64"
        sha256 "88a9b6dce17f3df4aed0ae3aaceec315c7697a2b667feda390d0e2627efb159f"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqry-macos-x86_64"
        sha256 "173af058fdf66a4d8a7f9179df265d7b6a40b1297c0df94f3c0c4845357ac4ea"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqry-mcp-macos-x86_64"
        sha256 "a68c8e2ae4aba9038c102962026943c4418bb569c8a1881e443cf1b023e5e38e"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqry-lsp-macos-x86_64"
        sha256 "4707b7f85fbdba7fa3503ec3ff13ab8023f656620ddddbd3550eaa859eaef6a2"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqryd-macos-x86_64"
        sha256 "a1dea8eb4ff2802b0b307b0a5c16a55175f49bc38c6046b9e777363f3ee2e500"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqry-linux-x86_64"
        sha256 "d4f462de058fdcbb499d795ed8981d510db0d8cb4ec0cc6134af1a38972b5636"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqry-mcp-linux-x86_64"
        sha256 "b82255b7e8aa1768940f873b0f3faffbea2cebf25b6330c1a5766d8df268a31a"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqry-lsp-linux-x86_64"
        sha256 "0144a58606d8cc724052d4d5d0e8344313d223658bb794adc6100081701af8d6"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqryd-linux-x86_64"
        sha256 "115a17211db9011bbb5e5fcb093d775ef390ea31432d5c8af1789e67c6a1c0b4"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqry-linux-arm64"
        sha256 "45a8ca074781013b1ff03c5895bd7930cb73c05679dc47fbec63f7ffa4853aaa"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqry-mcp-linux-arm64"
        sha256 "0c6b914568f5e985633c5dee5015eb78e05f804e5f65d6d07b6d599a3e75b167"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqry-lsp-linux-arm64"
        sha256 "a16a35f35af9b220cdcb3f350a691e374b79abb470440186aeacd411465373a4"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.1/sqryd-linux-arm64"
        sha256 "09040f76b500e9f5244e075d0b0523fb5e2d50b0ce4de368aaeff7ecca15a4ee"
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
