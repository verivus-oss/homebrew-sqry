class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "16.0.2"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqry-macos-arm64"
        sha256 "c925b3feb0d2b8cbe59f0c0d97d584107b678a02ba092f4c7866acc0af7ca9b9"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqry-mcp-macos-arm64"
        sha256 "cdda7fcb1583512e5275a140cec9ee543968eb293cb34a95f4675d6a917b7953"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqry-lsp-macos-arm64"
        sha256 "ea7b22c5ca68c4ebdc5a028ddb9946190c02ee3d66018c4647660643d8f660b3"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqryd-macos-arm64"
        sha256 "f16af5da01c192ae52bb7be1962bb6467aede342cf90c9455c4456fd54b71069"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqry-macos-x86_64"
        sha256 "2e65168ab6e7a863ee73db27ba7c605fd1a52994c23cb02b0c3f68b95f1db2ab"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqry-mcp-macos-x86_64"
        sha256 "fe226a46cb62a1f233380ad6a17f42e2c408b8ee065e4b109767c4a47ec2bc60"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqry-lsp-macos-x86_64"
        sha256 "0b5e578e7b740e61e2e5a4e9a7197cdd3dac668b8afd8a7f900bfc8e52011a1b"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqryd-macos-x86_64"
        sha256 "b6c8a0bca05a168a060404308cddcfd6b83ae8689e636b3a502ff7af84cebaed"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqry-linux-x86_64"
        sha256 "44dc6ea9404316a772daffd8837e2c2162ef24e6950d5c43393113ec8e3c796a"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqry-mcp-linux-x86_64"
        sha256 "7459d68e372581fc863942d08b1d9336fa83c7e25b5cfa89614b3c6080c1b4d9"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqry-lsp-linux-x86_64"
        sha256 "21ad9fddeecbbc6b21f8884efc6f92eab25a9f5c69778ece9974beef27dea2d1"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqryd-linux-x86_64"
        sha256 "eb10fa0e7031261c0801cde56ae75f24f031947bb94ac175d4fdaad11023c409"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqry-linux-arm64"
        sha256 "2ff923b0c47734887d35dc1961ef771b53256b45aaf2c108490ade9c2d838b5c"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqry-mcp-linux-arm64"
        sha256 "a84c4539ff887241d344df581b660ea9a6affb0edeab560fa24735071aae152b"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqry-lsp-linux-arm64"
        sha256 "5c5c2e16325be472b2d27d8072b09298f76d43624e7260e8dd87b1405d82dce0"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v16.0.2/sqryd-linux-arm64"
        sha256 "482c6c377149f2387a5815f88bf2b89d9443a196989ba8f8f0e278e66ea4b428"
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
