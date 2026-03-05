class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "4.8.16"
  license "MIT"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v4.8.16/sqry-macos-arm64"
        sha256 "9546b6fca9022aed546b87f7751f488dd3842a64a491ea2faf7936ca96f38a19"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v4.8.16/sqry-mcp-macos-arm64"
        sha256 "d90ea2d731577c192f3e103c9f743902c4453873ca3cfd5a81bc598ace28d8bc"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v4.8.16/sqry-lsp-macos-arm64"
        sha256 "72fb0407d7dec163e3eb2f1e9802d8c6b9aa3562d5c8b2bfea5fd76c15a8b41e"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v4.8.16/sqry-linux-x86_64"
        sha256 "12b8bb6327c386804a7c21a303b5312a0d38640d12f46956b7926358e935f284"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v4.8.16/sqry-mcp-linux-x86_64"
        sha256 "ae1d41f713f94a302fb6c3f0a29efec635371147977499e7dc95eac772b80063"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v4.8.16/sqry-lsp-linux-x86_64"
        sha256 "5897d802f9d56dcc034c4d8962a9263f39b3a85602accb2fb058a559737b6473"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v4.8.16/sqry-linux-arm64"
        sha256 "6876d83b4974ceed8bb898a8f0eabc1f0eaf795a9523877058393968c526b3c2"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v4.8.16/sqry-mcp-linux-arm64"
        sha256 "8d02fc52337fdfc33ace8ffb05a8c86a7070417b45e7106248b55e3706842345"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v4.8.16/sqry-lsp-linux-arm64"
        sha256 "d32a1ee621a934707481fa1fcb111a153b1f204b19ac188039955ad12f9cd5b7"
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
