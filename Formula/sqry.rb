class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "23.0.1"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqry-macos-arm64"
        sha256 "ddccb41435aadf4ba995533653a5ead43cfde3806adc1ef68c6bb289f92f166f"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqry-mcp-macos-arm64"
        sha256 "a109b061ecafe7d05774af1547a529014ebab30d68c41b8ae5fd73169fb2028d"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqry-lsp-macos-arm64"
        sha256 "7e18d15867e35f26549072426812f0c883056c4cdaab42bb7ffdd7284bfc8a76"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqryd-macos-arm64"
        sha256 "7fcb97effc0776de01f80076d140687a254e4add5ab1ed148ca8f078bc5bc9ce"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqry-macos-x86_64"
        sha256 "b8900644a909de4991fb3e6a2dd36e8126493d2cad3a6a4a3970862aa6d3b727"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqry-mcp-macos-x86_64"
        sha256 "e664fcb379b93f1e30d37de40f4375a8abed804f08460d684c26630337f74d7c"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqry-lsp-macos-x86_64"
        sha256 "be890be75d9b04f708dd17ce4473e216f1cccf290a40da84a346ab50cdea8d33"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqryd-macos-x86_64"
        sha256 "0ada0cb35b676bd22b6ad1178946c5ec72acdf7d3e046e41095c0468bf63c128"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqry-linux-x86_64"
        sha256 "34700656bf161c07f4526dbbdd167a639a97989152931fe9799839eeb27fd2da"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqry-mcp-linux-x86_64"
        sha256 "fd199659c529985710070430b8a835b0c7446cc0df76d33f0f902dba1f46ff3c"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqry-lsp-linux-x86_64"
        sha256 "3a04eb19e7a89e089dca35479829a1fd6ecec576d95729b3d129094d9748e665"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqryd-linux-x86_64"
        sha256 "75771d490596f4ba4a281443374b28e7f9f606449020f822cd12ccd38dd51b68"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqry-linux-arm64"
        sha256 "c70ce99fbed613c7bec0c53e9f24a9934d7bcad2f92a5681b22a060ba5cb8897"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqry-mcp-linux-arm64"
        sha256 "fca327d17606ff19f6f6abf6c8abca4891fdd7cc6349ded120ce6c0f7d6a587c"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqry-lsp-linux-arm64"
        sha256 "37600dbd4174676858d8eadb9a859b4f43884d4f46ee653585296a080aa07eb5"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.1/sqryd-linux-arm64"
        sha256 "f3c77e56d97f918d50b70f11c050c86ddf42733c1b41bd827e1daa260bd81b4d"
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
