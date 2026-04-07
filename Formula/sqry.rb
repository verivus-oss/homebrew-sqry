class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "7.1.5"
  license "MIT"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v7.1.5/sqry-macos-arm64"
        sha256 "15f2cb3ae177c749656367b71208e87cae54489e9445f92072cda98b4cddb93e"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v7.1.5/sqry-mcp-macos-arm64"
        sha256 "7e91ae892d203e9fd2d9e205fa2628021e737856d7c76fdacc4ebe0dcc08436f"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v7.1.5/sqry-lsp-macos-arm64"
        sha256 "47f5ec446865a5381a65be796de86e61f3713cca9298996887ae1fb1ec5cf2aa"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v7.1.5/sqry-macos-x86_64"
        sha256 "f04b8a4f64c7465e36703bdcb1810230d8d8199de671ff2be6caecce760bb183"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v7.1.5/sqry-mcp-macos-x86_64"
        sha256 "4c20e93e2810d4d5ba5e396b9c9d7c7f2cf2520b5fa7cb2dc703037bb9b775b6"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v7.1.5/sqry-lsp-macos-x86_64"
        sha256 "3b7d6bd053cedfc2db99d9673151f588959af0a822a565fa17466674dd67b18e"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v7.1.5/sqry-linux-x86_64"
        sha256 "54009b9ee9898425b89160585454e68b4ef615be7d1903068d30d83d3626d5f7"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v7.1.5/sqry-mcp-linux-x86_64"
        sha256 "99f8211b2999d4001857c71c5fa8001e875a5470e1230b37919ced0d2f450631"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v7.1.5/sqry-lsp-linux-x86_64"
        sha256 "d508c03ad9113c1cc7504084ea4e4565294980196030c93425cbc3e7121f0961"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v7.1.5/sqry-linux-arm64"
        sha256 "a88f4cf746d6d61bff28fe45cc7cad8c61501e697707c06efade769a669c2c7a"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v7.1.5/sqry-mcp-linux-arm64"
        sha256 "bbf23942c416127cafb152147b9a46802980775c9ecb37b87be894118fbdfcb6"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v7.1.5/sqry-lsp-linux-arm64"
        sha256 "b0276c2c9f7aaf56703aedee61fffdb59d92348d229f95ca1dd2783f5f574793"
      end
    end
  end

  def install
    %w[sqry sqry-mcp sqry-lsp].each do |name|
      resource(name).stage do
        bin_file = Dir["*"].first
        chmod 0o755, bin_file
        bin.install bin_file => name
      end
    end
  end

  test do
    output = shell_output("#{bin}/sqry --version")
    assert_match version.to_s, output
  end
end
