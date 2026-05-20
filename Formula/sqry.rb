class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "16.0.6"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqry-macos-arm64"
        sha256 "410928cc108b5bf66e966204ca969407edbb64b17007340ffcceedc0de9e3b7d"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqry-mcp-macos-arm64"
        sha256 "99c6c5ed59dbfa5edb5898a98b7c80319165cba1e863641032ba976290691f50"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqry-lsp-macos-arm64"
        sha256 "01798353436012100dbfb06a7e5f4ed3d6593dd3aee350c8f2a4e16a12b0eac5"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqryd-macos-arm64"
        sha256 "de85686769b5a211c5d087b5518bdb81d77412d9964522fed5bdc512a9435c45"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqry-macos-x86_64"
        sha256 "7cb00b8b78ebd01921df534799002f3e18a7795ef376e075943a6629763e5277"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqry-mcp-macos-x86_64"
        sha256 "2e6a3608d001f71eebebc195ada0941a1d85552a4afa640a84331499e082b626"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqry-lsp-macos-x86_64"
        sha256 "75874678d7166d902b107e6840110e767298f54c1ec32dfc4553e6009740816e"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqryd-macos-x86_64"
        sha256 "f5a46d7ccb3ab02d234c55fc0537ec45c59140135a815fe02ef484f93f733e1f"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqry-linux-x86_64"
        sha256 "f3a8f18b21986331df23d9b74c7bb378fb69746aa40be7334bede0ed684b0a7a"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqry-mcp-linux-x86_64"
        sha256 "6d60a7750cc4a85cdd53eb4d697385b3c1246ae2bedf1fe34d7c405aaac6d22f"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqry-lsp-linux-x86_64"
        sha256 "785a88078d17cdb74d4c42e70c94b47ac2a715b2adc55ff3712cd94d9f64a6a9"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqryd-linux-x86_64"
        sha256 "79d8f1f704bb922de695ed7b506a1bfdbca7ffd76dc571459e77c77d608d7ed8"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqry-linux-arm64"
        sha256 "1d1c701c1835938911485b9dceafd0d833e1ad97b8c21523da2888698c2b318c"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqry-mcp-linux-arm64"
        sha256 "95dc3698531941f2517e4946919b2304c3d90817a56d68a70405ef84f9be2c6f"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqry-lsp-linux-arm64"
        sha256 "f6dcee78c947d06ebfb2f019d2cb4a6e5853f3140c2ccf9711a29f233ddfd673"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.6/sqryd-linux-arm64"
        sha256 "a7256c1d7405eb195ff988dacf3d83677bd17b0e7256c8cd74cf390c7ee40121"
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
