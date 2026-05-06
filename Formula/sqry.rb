class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "13.0.5"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqry-macos-arm64"
        sha256 "80a24bf2113f542a2121d2fcd8e9002caeaa9708b63adf290c17ba4db1eae88b"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqry-mcp-macos-arm64"
        sha256 "756fee845359102d3b5d31e3a5d3bba5077f43aa83d86a06d418c770573ed43c"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqry-lsp-macos-arm64"
        sha256 "45a1c4920691c55ce628d38b38ba5327721f35a97d541ed60eda8a9b6bb97ca6"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqryd-macos-arm64"
        sha256 "cf76071943f92536c5c1ac9f0c6faebb1464b431f58f9c81139eaa2041ef5fa8"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqry-macos-x86_64"
        sha256 "3f43b4ea024cf1837f4ce977aa3d07d69a34a2b487607dc0db512826eb618814"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqry-mcp-macos-x86_64"
        sha256 "439825fa251a404b9106d5e487703f1142679119c69690fc422c893fcbe83cb1"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqry-lsp-macos-x86_64"
        sha256 "fd77a767aec66d274be224256fa5c7a96c8452bb4ae71d3f8d08cf7ac1a8afa5"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqryd-macos-x86_64"
        sha256 "dec91cc7af789850114f90cb8f09e6be5915fc73a8d5c7c5a4783bba1e372659"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqry-linux-x86_64"
        sha256 "c6b08a8e41ce681d6c01a0c44d0d7910883e535aa2c80602bccf972f7b71d73a"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqry-mcp-linux-x86_64"
        sha256 "d27eaf40ad93d088b36d0afc81f98dea5f7382704d7cc3fbf7472b88e4ebf00b"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqry-lsp-linux-x86_64"
        sha256 "a4eeac63cc6516395d2dd7aa0fe759c1cd1ca8746c6716abba8f0ad3a1cfce3e"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqryd-linux-x86_64"
        sha256 "bd5c6f99487e75fd791d00ed61b8f272647153e2268aaf4e9829620c2fd1e9ad"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqry-linux-arm64"
        sha256 "aa31472f2f62dd367227348873c56475c0e42ec2082ce5ff44dcefa666324f74"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqry-mcp-linux-arm64"
        sha256 "a150abaeff5d027f3bd5ee10fd66d301e82b5865e8e4d17abec6cd4f205ed051"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqry-lsp-linux-arm64"
        sha256 "78c4ff7da028fc2720857c1af7b67f29895abf5491f091b5c35600bf0e3a10fc"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.5/sqryd-linux-arm64"
        sha256 "2d1c6fd70dcf1ba415382c2fc3b4c496bac9dc6228b8b9af16f74dc63ae3b32f"
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
