class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "30.0.1"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqry-macos-arm64"
        sha256 "083e77fa5b3397e94d4809f5f1b449a43006f6f1e7274fcdbad2b796298f9603"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqry-mcp-macos-arm64"
        sha256 "22e11e9ec1d41f32b56088b5da5f345c062477797f5038408de4c205bf4dbc9f"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqry-lsp-macos-arm64"
        sha256 "cae7eca4b714330c37501dd42170c43e8185306490c40b1df2205ae3a2a14deb"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqryd-macos-arm64"
        sha256 "2e8cd3f4fc67f81770fdb228fe9ffe836f2e54aeb7ebeb8945b8cd1276c5c72b"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqry-macos-x86_64"
        sha256 "9ea5c117ad58319db173204779a6dd28d0f2ddbe57e0fb483f151f0602ef7626"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqry-mcp-macos-x86_64"
        sha256 "16952a688650f9cca2ce2bc276c3ae2237b4d93986cff5c89d352f4594e25454"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqry-lsp-macos-x86_64"
        sha256 "cafa8871e03a89252f3734f24979ad14255b1d8ee495bfb8b9f1b4c1e95cc4e8"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqryd-macos-x86_64"
        sha256 "72785697f77146cdbe24c7761c95c995b131b51943255390a86e1d57c5822575"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqry-linux-x86_64"
        sha256 "8f9ab327544c498a2bef6b640c5f21fc4b4c6602e9f36fdee36872b1dfb9538b"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqry-mcp-linux-x86_64"
        sha256 "410ece073caf9d1e9df62043cb73cd07ccf0ac475c92be008718d7f719ff9765"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqry-lsp-linux-x86_64"
        sha256 "f8afbdeb8f1c337c6b7c1ca42e4580c7a56d63f646cd1da0d2ddac191a55ba12"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqryd-linux-x86_64"
        sha256 "fea1d9a34df5b126072b0ce34bc5ce89be42d2e257e98150b3ba046652550530"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqry-linux-arm64"
        sha256 "1f12783bba92ee328640406276693e1d8a66b43315b74a389d6a7a37cf0ed2ec"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqry-mcp-linux-arm64"
        sha256 "2bd41fbc83bb9b17b07c604fa2ec48667961890be92119d8982cf40e65a52439"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqry-lsp-linux-arm64"
        sha256 "b3340109358622b7bc49f66eb361b1e2fdc6c5a9e940ab89b28acb1d94e55ef5"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.1/sqryd-linux-arm64"
        sha256 "94e23f760fc0d868dc625f7db2d3459c71367e4dd30dbf03e2738e0a0735940a"
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
