class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "15.0.3"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqry-macos-arm64"
        sha256 "8517b2311becedbe9ad8065bb154d8f29b8197814097ff986366e702f684707e"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqry-mcp-macos-arm64"
        sha256 "2c480b35c46a218bc1610b548ef8aba5ae261e923b0fcc242936993fce0a99da"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqry-lsp-macos-arm64"
        sha256 "6663a534ffdcd4ebb86186a2db7660c120341cf688b8bd09b9b070934da4f931"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqryd-macos-arm64"
        sha256 "1dbb00166c9a17705f1e6970d3d750600f5063b23607a93ef5d579f1073cc651"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqry-macos-x86_64"
        sha256 "e5d48b8f69c9003ff7a0750a1176988d11ecd8647aa46ccc78c1fe70ea93a37e"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqry-mcp-macos-x86_64"
        sha256 "10ea676e7d485051ad41b7c0b5081d6a57b789d0ae1bfc69337ec2d139a284cb"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqry-lsp-macos-x86_64"
        sha256 "36d69a3ba9b77f822b02751ef34fb65c3225fb5577b8f488e9ba16ebcd3fde99"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqryd-macos-x86_64"
        sha256 "4e7cfc6dac0e9d678160db0226ac7150f09b53537d895f4cf4c3bd06f8d15cf3"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqry-linux-x86_64"
        sha256 "40781dbac99c61d17100ad8ae80f7457dc01150155f1da087998bd449751c9d2"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqry-mcp-linux-x86_64"
        sha256 "e54a6195e915610bc730ee04dd5a4aae6552b24a724db0f336f89183fdc0420a"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqry-lsp-linux-x86_64"
        sha256 "38570f1e54bef8e063854a15e51e407ba441ed2e614f558e3541d99ffa67e0e6"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqryd-linux-x86_64"
        sha256 "6163d985e3a5c6ddd6928db196a2f578ce7ad50595b76d79dfaa9da197141fdc"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqry-linux-arm64"
        sha256 "5be0a2fd08d95c8fd6964264df40c26b7fbb0b04b96b69b15f0cd1bc06e59d54"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqry-mcp-linux-arm64"
        sha256 "a11100b66bf09a83df21eb9f4586915c5bf98178bfde90f3484409fb402c627d"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqry-lsp-linux-arm64"
        sha256 "8a9dc5b8620190772cbf5ca3825d6598a2eaf04836ab02917bcb214ff00b68e1"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.3/sqryd-linux-arm64"
        sha256 "e41593c89663d81bfdb21a5a632dfdc1ae66321a042a96817a00a65ae80a7659"
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
