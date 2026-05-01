class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "11.0.4"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqry-macos-arm64"
        sha256 "7e77f973e5fb0b67d78c746b93ea711083f36e31f0ca28b8ad6da10404fc6baf"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqry-mcp-macos-arm64"
        sha256 "8321fa79c02750e600404f82a2715ccea95c8df699cb717472c8b0547999089c"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqry-lsp-macos-arm64"
        sha256 "8c6c8cb85ddbc93990cdf5d83328cefd716adaa3886ad45eead5ca3667ae67e6"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqryd-macos-arm64"
        sha256 "e15c7d97adaf280077dccddab8d86802794294e7e4eda6a8bd7fb17a628b8e6e"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqry-macos-x86_64"
        sha256 "08bffcc4af4f7c0274fef19c7e0f8790eea894256cb0b39695debba012311ef1"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqry-mcp-macos-x86_64"
        sha256 "bd7cb984e711abb0823ea882775d973757bcaeb4f84c9e4be0617302d40cfa69"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqry-lsp-macos-x86_64"
        sha256 "f3b262b73f884124d767aadb858b69d87b5aa2a03ea0a22210765da2eff01cba"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqryd-macos-x86_64"
        sha256 "0b36fc97930d2efbadb12d1a649f4d25a8ee4c7e0bfbc3b5269b5cdaea0695ac"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqry-linux-x86_64"
        sha256 "8906172319ebb914e478aada8ead233da09d58dc2ee00336175edd5120e3deef"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqry-mcp-linux-x86_64"
        sha256 "71c1dd422387d020221dd9f2fc7310f2fe50b61694ce03634663f6bc1d2c8e3d"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqry-lsp-linux-x86_64"
        sha256 "a935e1ee4380d198c187084413e04acea0c2c1d8793b42455bbc45d76423e4d9"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqryd-linux-x86_64"
        sha256 "0e47b1f7e7a7d6b75ad22652dbc089957769162fb448212aa22298a1e4e9b5c4"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqry-linux-arm64"
        sha256 "0d0771fb8cb01b5706ea84cf2b327fb25093021746aad201fe4fe57aee1b47eb"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqry-mcp-linux-arm64"
        sha256 "f81764b47c796b90b18cbe448120d28ccd548be461d8cac3afcd0a1d184ccbfd"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqry-lsp-linux-arm64"
        sha256 "85218e099dd55d86a2e1e707e5e63cad4cd86fe6c22563556b32f74a11262cf9"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v11.0.4/sqryd-linux-arm64"
        sha256 "a6dec751ec23178e107d91bd7fa895752b2a2d073067cfea00e0c168b1cc0911"
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
