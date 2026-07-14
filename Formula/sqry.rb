class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "29.0.3"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqry-macos-arm64"
        sha256 "320176b99322ff7e164a61b777a5c2db0b59590ac634fb2b6b6ff71976671999"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqry-mcp-macos-arm64"
        sha256 "2c84d763cf45a8fafdc63ab61c4fa272a971854e423c146fbf30b53a2710a40b"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqry-lsp-macos-arm64"
        sha256 "fc0f4d27fcb44fabf858bb36f2c11c487fb9ea1d77c3d876648a2af631eebdc8"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqryd-macos-arm64"
        sha256 "68bba07fece089282ee86b6ad9765b767422c56da346cbcab78f1bf7fee05a25"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqry-macos-x86_64"
        sha256 "203dfd3bbb51155238b43e4945773ccff03e8d5a7238c55f6422955ab4f22c81"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqry-mcp-macos-x86_64"
        sha256 "4bb493f46792b95875cfe5e6b628a85af7f5b6120902cdd291d151d348a8c1a5"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqry-lsp-macos-x86_64"
        sha256 "110bb94641bf1d7eab9baa7ef11636393b1249e4636b3ec231251008155471c7"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqryd-macos-x86_64"
        sha256 "3fd82febb71bf703c0a28cf45f9975f5034a374097467226ffa4af975d03b231"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqry-linux-x86_64"
        sha256 "aecba8f0ee75884023efe7053f087c012ff67e031c80956d7c2615c9c1426025"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqry-mcp-linux-x86_64"
        sha256 "e2b2aff3b7dbdb6f3bbe8aa80af145402a903267000d924158a2b1041af23f3c"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqry-lsp-linux-x86_64"
        sha256 "920fa55508c6492554bb0213689b5c0f96d25ee434baa865957880b1276e1084"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqryd-linux-x86_64"
        sha256 "cd8c7e2d56e944ec14af4fbc665e82830036c953b523e5d66b20f351864d7a28"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqry-linux-arm64"
        sha256 "264245f024e41593073f4ba754df1cec38d6500d066ae88e393e996eb1e8405c"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqry-mcp-linux-arm64"
        sha256 "a99e23c48e84f9cd290df7b53a7e72fc470f658c809c3ee11923d52404e46613"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqry-lsp-linux-arm64"
        sha256 "bf081d8c9e27663792cdf5dc5df14b5b7e6aed0c60294f3a39ee263a8bab9caa"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.3/sqryd-linux-arm64"
        sha256 "8a81157262ae5e4f01ad556a30f6f0e444747cf34b1845aaf1ce341b9edb70eb"
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
