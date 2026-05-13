class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "15.0.4"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqry-macos-arm64"
        sha256 "7731afe4759e2584b9cb54435af6d28abefd0b218f78c6d0014ade31935d16a2"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqry-mcp-macos-arm64"
        sha256 "394a84cb0691a516a2731c462f05f51cac62aee40521e09554b6833a945aa889"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqry-lsp-macos-arm64"
        sha256 "6a37c87337815c98f3b9a84e3e85fa9207f52b25db83be2f4dd8aa9a7b6fde98"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqryd-macos-arm64"
        sha256 "f9dcc9a81257117b6943f5bf0fd1cbbc77323c5ca8a8deca2c7b61c72fec4540"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqry-macos-x86_64"
        sha256 "d1a1d714f8cbd3715ba2d8923a95bcff8e0590ab47370d3ef4d900910b268470"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqry-mcp-macos-x86_64"
        sha256 "48166c81c2aba5bfa735d91ba0cf431c2a693c0a63a410b217adc1783fd940b7"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqry-lsp-macos-x86_64"
        sha256 "6d406b93ba396d5a74bdd2a360502adc70a89246b902c69e8e756a2a91c1d451"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqryd-macos-x86_64"
        sha256 "656082a3a7c9c20a50696cd456b61a3f5c31fd3e7f8a20e2964f278031efe03d"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqry-linux-x86_64"
        sha256 "0dcee985e6f790238df73d501de33810d5e4824b348525cb687f0ab0877f1d66"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqry-mcp-linux-x86_64"
        sha256 "fa28f585ec2512c44b8bc1e8df7a44606786be09af7e21aaeded4e5b56ab727e"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqry-lsp-linux-x86_64"
        sha256 "35ee374706192ee4d2c9d265b085605c27d3bf0a007ae40de0b886f9ba9646c1"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqryd-linux-x86_64"
        sha256 "d491a747dd8d2b358c07253dc71dab248d9401339cef41dfe63f2b674f63198e"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqry-linux-arm64"
        sha256 "9eed73c73210f96229a08915737c8672e3a7d3b893f034b4a40a1bb2bf5ac1fc"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqry-mcp-linux-arm64"
        sha256 "fd85ab8a701b91f045ba0fb527e389e8ba078c19ce4a28f53794c8fab91a7355"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqry-lsp-linux-arm64"
        sha256 "a48d8faabc945fd9d59d40e67cfa76c6c9b1cad410c516ea5d1c2e67e0f98527"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v15.0.4/sqryd-linux-arm64"
        sha256 "343721e488ac1cb73c12f794a5852b36870e15841ccb76833b65be8032a8944a"
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
