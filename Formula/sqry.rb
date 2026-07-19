class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "29.0.6"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqry-macos-arm64"
        sha256 "2b6b77fe9f640092fb49dc3ee47597e537260de2902fefa77aaa70456a2586eb"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqry-mcp-macos-arm64"
        sha256 "32aef53cebf39e31fa6c938d8660aec239e3df438f50984bafc0ed1793718929"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqry-lsp-macos-arm64"
        sha256 "b5ab29b73fe503812af2a364f6a12821f647763db6dddfc2b03d705933fc34fb"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqryd-macos-arm64"
        sha256 "2957ed72e0c076ec225ab73de30f09acfda820325da9848bf64dab1f43c2898d"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqry-macos-x86_64"
        sha256 "28a5fc98b5486f110219899dfcf34c01f8270e5249309ed1c0aa23ea358df58f"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqry-mcp-macos-x86_64"
        sha256 "d470f47d6639668ca7863378178c4772ea6fb9f0ef7eb9aa8f938ff8138a4e49"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqry-lsp-macos-x86_64"
        sha256 "cbffc831d628d2b820f0a2f143540131506416f447a81c4c3b5c6ab1c52cd21f"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqryd-macos-x86_64"
        sha256 "f361d0604ed43e74fac48d1d43be2575aa2cd17012352a6738815d151cad3f8e"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqry-linux-x86_64"
        sha256 "16dcd78008bfcd8924b4077586e399c5ac871826db0f95cf395e32c7e173016f"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqry-mcp-linux-x86_64"
        sha256 "0a43b6935e97659c9157f37c6c1c69c6d3bd70d6929becc9ebbb59d262aad7af"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqry-lsp-linux-x86_64"
        sha256 "72e5637e6c85ee1573c765225f502e15454d14c9974326fbedf878d79d0e1f19"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqryd-linux-x86_64"
        sha256 "8766eecdd2bee76332a37727275c7b2eac813231568fee9de9e32c9147a2695a"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqry-linux-arm64"
        sha256 "39a498c90b6e0b86991e081a15e3672e6068b7849c8dbf8ba19080ad61eadb41"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqry-mcp-linux-arm64"
        sha256 "b205c5ce65dfca3adacb503b4b96f345027d02efdd7ed3393db938d9405dbd9b"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqry-lsp-linux-arm64"
        sha256 "49248eee4c2aca1985fda77a5003f5aa927750ffa754efb32ff8c9adce7f6898"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v29.0.6/sqryd-linux-arm64"
        sha256 "768ae901af33b0dc80616e2673880f439df4195acc6d6656daaf85b330c0bd21"
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
