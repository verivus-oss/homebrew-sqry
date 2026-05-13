class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "15.0.6"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqry-macos-arm64"
        sha256 "b13e964e2592eb664e0a5ac75aaeb03b48d236c9ae2f76d07f29b34bcbb1cc50"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqry-mcp-macos-arm64"
        sha256 "efe2cd402986ae9bcd9360fe61d33ccb2ee915caefb2252b328f0fe6c06105c5"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqry-lsp-macos-arm64"
        sha256 "49efb930bb1f60efb2729ada8f04e6275764376c7e4f68ef3df3c209686d9af1"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqryd-macos-arm64"
        sha256 "c3b36f1fdd078ea8436a3cfa5eb3348d0c8406d762db8a6f7d95c8a8230417a4"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqry-macos-x86_64"
        sha256 "ff4f64b6bd4d2c4d6e24dc36c2f09ed8b225c34e235947c56862188ed07aa8b9"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqry-mcp-macos-x86_64"
        sha256 "2a4ea5ad45ca48faf4a5f56cb1c40b33d868377103c61c6880e737c8e985df0d"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqry-lsp-macos-x86_64"
        sha256 "d8fbbef7b168bf3e1cd77ae5ab1aeb5944b29ba2c98fd49cc134016aff4eb4ad"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqryd-macos-x86_64"
        sha256 "cfec1fa3c8585aea569b5e0042bd6e39ab0692decf774c06da440215aebd12c1"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqry-linux-x86_64"
        sha256 "435f27e80175deb7955ac0c4a4306b389c45900fdc4d25ee854a9cad753a3dca"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqry-mcp-linux-x86_64"
        sha256 "c943d6dd9505f3c96ac0facef5d4a580795f957d5aed579ac90556c0e67d8e2c"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqry-lsp-linux-x86_64"
        sha256 "f10dfb8c293008317abd3a5b02f3b4ab433897bef5bd6580cfb23e02e8093927"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqryd-linux-x86_64"
        sha256 "3bac44d07ec4a1d86bea1bff8b544b8fea7de9b023062c4307faf9ad2a9fef54"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqry-linux-arm64"
        sha256 "a3391db0341feb23763e9669a183adb8e45d027f085c01568bba2aa2dca730bb"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqry-mcp-linux-arm64"
        sha256 "c7f9a2151a586749487bfacbc357c03b2cae226930203e4e7ca1838b6d5bdf63"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqry-lsp-linux-arm64"
        sha256 "9e1a84de765a3c1b5ae350662d3dea0b222a42d3f8b0de31846d5f54a2997af5"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.6/sqryd-linux-arm64"
        sha256 "c28bef7f2fe69233ce6f9fa3517b8b3dbd80d34ac3179a5e6c5cd549e9364b20"
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
