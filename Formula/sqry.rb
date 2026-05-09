class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "13.0.17"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqry-macos-arm64"
        sha256 "70ae4a5c5a40d4a720978335ceca49058e48e3d492168781ee711077b7673236"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqry-mcp-macos-arm64"
        sha256 "6e5c9c2975c99f9ef6b9a317cb62b6798a4299871df6eed6d415dbacde931a89"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqry-lsp-macos-arm64"
        sha256 "5b67d829b61320be2afc5d22ceb3eb8c23689d9fad4a17134406cbce138a9a61"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqryd-macos-arm64"
        sha256 "5f7ceb27f4e17468945b0dc940aced7db845e847773a54295b70590a49a6ab7a"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqry-macos-x86_64"
        sha256 "533576648d83b1445afaeb69f4ce7ab41d799aa769441dd9615030e0aee5f22a"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqry-mcp-macos-x86_64"
        sha256 "973518e80406614927e9bc09020ca221ef4b67283d86badd922e94b0730efd06"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqry-lsp-macos-x86_64"
        sha256 "14a273b4ed9f6c55fe534e6b07cd3ff9bdf35aab8e1c030068bf06b759ede0cc"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqryd-macos-x86_64"
        sha256 "de12caa00bb53404b2c82ce9f586eadf15a2f75fb9a0dcca0b304a547a50b1bb"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqry-linux-x86_64"
        sha256 "74d12f288d135c360959a010f903a49a12c391bde0bdad6053b94af0903ac1d4"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqry-mcp-linux-x86_64"
        sha256 "a134286071cc753d54e1fd7bce07e1d5db6b90bfa9d278f8fc97a2206a5dc1d9"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqry-lsp-linux-x86_64"
        sha256 "0597638c87249e51b41cf3dc05133dc80b803e48f7f37b19d9388a6dd4ff8cd3"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqryd-linux-x86_64"
        sha256 "e799821981aa1e57d32b03a954d3ac2f277c83b490a30027d66f0a0428109fe7"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqry-linux-arm64"
        sha256 "b18a9a6266869625be7f95b7e8efaff59ee46a70e9531a7a57edf795cdd555e7"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqry-mcp-linux-arm64"
        sha256 "f3878bb037f4038fcce6308ee295630619e3556fee7903284013c2b52b66cc84"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqry-lsp-linux-arm64"
        sha256 "0765e5bf7ef02768ae34a8520921e94c1141bfe454f9bd9d6fc51dc991b0335a"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.17/sqryd-linux-arm64"
        sha256 "3786b341312884b27e6f64df2d5cb63f779fa1a430aa8c5721c4f19ceae09e85"
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
