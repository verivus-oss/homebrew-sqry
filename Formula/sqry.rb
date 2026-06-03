class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "18.0.9"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqry-macos-arm64"
        sha256 "96a11394258ef62e102a714feebf151254b3dfa9cf2b98c9a7ba9418a6aa80d2"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqry-mcp-macos-arm64"
        sha256 "64577aa8718bd8851294b3d8c0a3091014ee8bf5f49858c4034614c32e6ec869"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqry-lsp-macos-arm64"
        sha256 "e05d4a9c1d636f09518e999a1cb4e3c9d01a875d7abc83f115b58eeb6a08ac94"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqryd-macos-arm64"
        sha256 "473e9a31d94bb7f9c1361710200504f51132386c277f12b53816c1e1b2565ba6"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqry-macos-x86_64"
        sha256 "37aabe70bc501e80ddd788d9a595ee95f6a31706c71e978fc1e6d07e73e9bfa3"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqry-mcp-macos-x86_64"
        sha256 "d67af96984b6f7bf235e54d6fecf93623280e10d4ced2358031846a6b56e9d4a"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqry-lsp-macos-x86_64"
        sha256 "5820c4a57cc1950ecccf8bd7e49d7a2949820ab87af4f695804bb88816ce2338"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqryd-macos-x86_64"
        sha256 "1897a0577fb05644e2c4365c241cee19a1421a541392cfc1a1f8c61c97c97ff5"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqry-linux-x86_64"
        sha256 "2a88258d168e98ff55e230b55c0db843d2db2a5ab63645508074ef8d9b81f6ee"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqry-mcp-linux-x86_64"
        sha256 "61bc424b831337fe3ff2a5616277fd57a4af671f44b9a33ba42f25be3c296144"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqry-lsp-linux-x86_64"
        sha256 "283c12d76db192ebd511d6712dcd90b16ad27536c9707cb2fe68086a8f5af28c"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqryd-linux-x86_64"
        sha256 "1a3ecb9c179619af1bbaa08642a2e71116ea66eef3e485f498657f6a07c22af2"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqry-linux-arm64"
        sha256 "0afbc4f2cccce0657f00036d0827a8f32cd26a2464e830235dfa5f8d0ba48401"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqry-mcp-linux-arm64"
        sha256 "831aa4b157d03242fb780e4720751148e1484508b19c135dc056e454cfb0ee9a"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqry-lsp-linux-arm64"
        sha256 "3da83cf18e65d5520215bb24029e6bd5a0505136941bf6648afb910aacd9c6c6"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v18.0.9/sqryd-linux-arm64"
        sha256 "274bffccabd8e79b55b25c4c7adccbf6afeacd1a7ff339f5b2f5957d7208c16c"
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
