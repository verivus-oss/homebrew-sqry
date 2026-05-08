class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "13.0.14"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqry-macos-arm64"
        sha256 "991ba566c39d030e8a2e66248f3d6ee09f9a52707650113335ae667d1eded3e3"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqry-mcp-macos-arm64"
        sha256 "897cf74e1b5f4c0576fd1b2c2ce445d5af940b6803621b8fa15f6039e5134921"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqry-lsp-macos-arm64"
        sha256 "0aa69176a3e6a01eff6cf6f3663e8b7eb7c90e48c53930c66e6b355f6c2e97d4"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqryd-macos-arm64"
        sha256 "9c44ebef81dc53b46f380e31342c34db4dde0ecbc79ed747b4ede8706bb3d3dd"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqry-macos-x86_64"
        sha256 "62886eec151452cbbb8ee120715ff67402acf8a03945067c3a2f08a01fffa32e"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqry-mcp-macos-x86_64"
        sha256 "10f51fa276cf5905c227d754f6f3f68a739262665d5f3b483204536eafbd09dd"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqry-lsp-macos-x86_64"
        sha256 "939f2feed7a1d56ddb47d957dba3e588501b571c990790d4469c9e9e1055bed4"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqryd-macos-x86_64"
        sha256 "a05638287673791dfb0f2ca3f7f76ff0c6218596fa5d1f5e12fe76a064dcaff9"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqry-linux-x86_64"
        sha256 "c879ccf949a13f23fd354426f55a4d3905c3e78f284fdb9939cf68ac3e8f07bb"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqry-mcp-linux-x86_64"
        sha256 "4c8a2f6b540c0910600244d1eaa6bd9faab6e2233e586861df541b3e00df3aaf"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqry-lsp-linux-x86_64"
        sha256 "d4a158e2fba902a4a7c56c5b32ff5b6e9caa2e2315244c68464f7a65822f51f3"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqryd-linux-x86_64"
        sha256 "69b0bb17e373dc1b5a224ca57ffa55cf4a7ffc33d35f1d15e36bd923539baf2e"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqry-linux-arm64"
        sha256 "2945d62cfdacc359f20582ff5b38e0155300c66ed5cf836c27e65fd0e4465749"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqry-mcp-linux-arm64"
        sha256 "ccaa4fe3a457d85cce3d2dd67c07aae2638713a19630202a0568a73f712b0754"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqry-lsp-linux-arm64"
        sha256 "5e4e265d054206915643fddafd17253a7abccdc507626cb8c2e1ad3dc4a7aeb4"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.14/sqryd-linux-arm64"
        sha256 "b0c6b44d15cc100492a551d2e9ab559ab604a0b00bf4f6a97a479dde2baae1b3"
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
