class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "21.0.1"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqry-macos-arm64"
        sha256 "2a6c328316387495a3333a4d7e6d25df491db72d8879e414877f51540ed25db1"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqry-mcp-macos-arm64"
        sha256 "b5bc9e8d69900a09dab2c4fe4e58c993f9470150d8d767fe7a1b3d350a74321a"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqry-lsp-macos-arm64"
        sha256 "fe7173bda81cc6f98c14a324ce99f3a8efe528d4a93c0016cb012ddacccb35c6"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqryd-macos-arm64"
        sha256 "52d83394878b56f04062d3957c0fab3d9f101b426fd458c9cc5a3007f99eff00"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqry-macos-x86_64"
        sha256 "17727f0d0542616e3cba2d01ed109533ad2ad405935ab2c3ecc05f419dca134b"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqry-mcp-macos-x86_64"
        sha256 "74414483aea35f0347ae55d4aac539703eae5df7cd232232e83b837520bb0fd0"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqry-lsp-macos-x86_64"
        sha256 "4eaeabb9c71c5b0a7bf8de89211ddbb5baaa07faba166544f4bd60d28cd10df5"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqryd-macos-x86_64"
        sha256 "f1e7b585c646ac30b2d7512ad2a48c87e52c6a36b05d59ee72e4ce170dac8896"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqry-linux-x86_64"
        sha256 "78a3a89082f966994c52f4ceeeff33d4b36c89ef8a34137814b354db19d9bedb"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqry-mcp-linux-x86_64"
        sha256 "817c4974bd3b36035cbd48d89254ec5be4581ef6682e8b58bd9a265cedcdcaf4"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqry-lsp-linux-x86_64"
        sha256 "2421e703a62aaebc3dcb77d94e968f0a7e7152664cb7d4b886c63cf19ef7bc05"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqryd-linux-x86_64"
        sha256 "845647743bc6df99c68d6cc67ef331584d6ad4ee743bae8b58c8131878826ed8"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqry-linux-arm64"
        sha256 "905423caf76e5021373d86c46d18ceb615e69f18488e3549d0f30500cd6a7484"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqry-mcp-linux-arm64"
        sha256 "74f31efbd071957f604f1d74c9fef4444d3d3a02439371e941a5139826c6ff70"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqry-lsp-linux-arm64"
        sha256 "4b49568d76541f47838ed7d0ad30d5e82ad42623fee89ba100c4ae45b2505e95"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v21.0.1/sqryd-linux-arm64"
        sha256 "9ac980f1f4fd0b2f44cba184a33b02f6c787ac48ada0cbad1f79d34e07a4ee59"
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
