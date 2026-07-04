class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "27.0.4"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqry-macos-arm64"
        sha256 "5915bb60b97988b4e07f69ebbe1bd14329c6c4cc3e0c5a5933f0a8fa1a018583"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqry-mcp-macos-arm64"
        sha256 "8a45d02c8bf1e1c75537411d853351a4607ac7baf8c079498c80a79d6b2f35ed"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqry-lsp-macos-arm64"
        sha256 "f13fa46c900a40d6310866e9d40f2563b536ea1b8a4ce22be92a1cdda6b99fff"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqryd-macos-arm64"
        sha256 "c32237864dd7bbeced25af291f080f2733accfa940f3feee1ebfa015d7b8844e"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqry-macos-x86_64"
        sha256 "991cdd71bf1b7109bfb93d78c65a0766a09b8a92a8bab68ba54003002f9b9b7c"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqry-mcp-macos-x86_64"
        sha256 "1efc0a2de9bcdbd0546dcf18645e8a5b8516eb4d6d4e6a8f087676b8b47aa1e3"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqry-lsp-macos-x86_64"
        sha256 "dd91b7f394b53006c12de299206d783e0992a6cd71cdadc7512615c32b75b00b"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqryd-macos-x86_64"
        sha256 "80f4fab4e23710b59f0c09f3e76179c338d40cc97b4d33393b06a4f5a305fc07"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqry-linux-x86_64"
        sha256 "4f8532304fc73fec14e3f70e2fa0003ab30eb4bcaa604fc197c7b10a5b2ec2f0"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqry-mcp-linux-x86_64"
        sha256 "7e0ea189c3ce0f879f3b11c38734bc0e863d76452eb7caeafa598b5fcc50eeca"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqry-lsp-linux-x86_64"
        sha256 "e14d7d6309b15f9fb1b7d1cec19267114e05e913864b811c4e730d90ca986e9a"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqryd-linux-x86_64"
        sha256 "7f82e3753e0a68b906f41bd6ebf94e984b86c2769d87f9e823a7f756d7e60d8d"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqry-linux-arm64"
        sha256 "c5662c6fe2fd1550f398d60d9852fd1dd116bb2309cf5e317767203aef632c00"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqry-mcp-linux-arm64"
        sha256 "b91db8aa3e2a6249ee53b0125f025315734333019aa798439a1521ed2b68a46a"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqry-lsp-linux-arm64"
        sha256 "cc27446ed8c8a24b7e09520b5e57b0f3893da2ab2dc28d35411f826683ef57a5"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v27.0.4/sqryd-linux-arm64"
        sha256 "956736acc71e95a35e6a80f5bd5adb26fca37bdb5e9a6edac8c8ac8235de3f2c"
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
