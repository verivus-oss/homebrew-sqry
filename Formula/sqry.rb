class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "18.0.11"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqry-macos-arm64"
        sha256 "e57ba317c59eaf96acea1bb356065f263e7b59350b221924b742c7c4c07cca4e"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqry-mcp-macos-arm64"
        sha256 "17473e3eaef5cf60cc22af3a7e1f7bc6926e6b49c49978c603361a528fdf21f8"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqry-lsp-macos-arm64"
        sha256 "804b5d6e0ee05cd0a47b50557da070fb06555a4c14ec98a948d4de76d09591e0"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqryd-macos-arm64"
        sha256 "c14282963e617abdab2b71ce1a1c5e9c479e10f03318d67b3390261ee4b0aee5"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqry-macos-x86_64"
        sha256 "7c736a24bb0a682058b8217351aa660abbfd4d81a55d34064f059fbc034bd2a5"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqry-mcp-macos-x86_64"
        sha256 "bb63cf032b224fb478e3b62add13e9494f4509b7f8c0fec2607a4b0253c75f71"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqry-lsp-macos-x86_64"
        sha256 "82350b686dfc4198c05729175c5119669eba3f25e9723ad42fb8d57312044b4f"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqryd-macos-x86_64"
        sha256 "0713ef4b579c7769fdbdab04bc8e9e5bd60337e229b348b971e0130bdb55fbe5"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqry-linux-x86_64"
        sha256 "f8abdd82f257099d055c3f09f1fe0358d8629d37e5801a6916862a663ba3ae82"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqry-mcp-linux-x86_64"
        sha256 "3f47dfbc13125cf6359356ca7f9000faf2078847219f491139cf41de0cdff559"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqry-lsp-linux-x86_64"
        sha256 "c2a2b2904688257aa92e6ad57c6fe86b203ef989eafdc0e0a025c16a38435492"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqryd-linux-x86_64"
        sha256 "0d4b568ad2b78406248350689821c28a6f256205e56388926ec0ac4ab9efe531"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqry-linux-arm64"
        sha256 "3980b393721bb1c5dcff6233fa7a06ce77bb03cdf151676fb5ea15cd6ac8a73c"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqry-mcp-linux-arm64"
        sha256 "fa3e0eba75be6b91775541538bf7cf62e0e71a5e4ec2aeae397b1735927d3087"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqry-lsp-linux-arm64"
        sha256 "2b3fb81e060e131c24adc822ef886d42d8984258c94a229a1c3ef08654b6f6e1"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.11/sqryd-linux-arm64"
        sha256 "f9ee21024f3ac36eb78292387309bf4632a6bb71cbaca53e91a4e83d16eecaa2"
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
