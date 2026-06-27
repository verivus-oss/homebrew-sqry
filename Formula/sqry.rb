class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "23.0.2"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqry-macos-arm64"
        sha256 "5cc6b68b2e81be594a9ff2bdfaedbb1feaff882c6eb3f17462a53358dcc71b60"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqry-mcp-macos-arm64"
        sha256 "a9b853958ddee21fb36b4a4c25519694d586d2c628258f8b5c011dd447095684"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqry-lsp-macos-arm64"
        sha256 "8ce6ac561aedbbb9bd503b7eb5ce6b259c1f0a650e720e54afc77b1142677a13"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqryd-macos-arm64"
        sha256 "f333e580e6ab088b7f744000aa9e3eeb7efb2bca0f124c19d477e1e905a0bc2e"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqry-macos-x86_64"
        sha256 "919f836c9b42e089f44aeafafc96505cfa1417957665e35a20a77d127d74ec46"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqry-mcp-macos-x86_64"
        sha256 "1a70f3760adae0e8d0dff22ec6a1c0dc253113433f1731907d4947c6905613e8"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqry-lsp-macos-x86_64"
        sha256 "56cab61fe9d4f06b6f32af9c8ccef4ab27c88f49ad4c25fd22655ed44a1af4e2"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqryd-macos-x86_64"
        sha256 "b6cdc1177c94cd70e682e659032256edda0054ef01dbca270279a4c3d9d947e8"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqry-linux-x86_64"
        sha256 "44fecf6462055926fc73425dd8e55fd41f43b65194417d17c3e8fab3001558aa"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqry-mcp-linux-x86_64"
        sha256 "b9c26f56e5cf03e2e0b445deab7cfb54d0ebad360d5af97499826853436662b6"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqry-lsp-linux-x86_64"
        sha256 "8566d5d8a80437da059305ec6051037720558a51ae6f368cd989e283464ba68b"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqryd-linux-x86_64"
        sha256 "f62b24dac77bb96173d54261020b1555ec64e0c0e6e9737ccf719d94d825d244"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqry-linux-arm64"
        sha256 "0b1b598a08ccbeb0538bd2be47d810243224bc964ca62eb6bfd1b4cc4ec22d20"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqry-mcp-linux-arm64"
        sha256 "9ae413324e36df546981866453354f677b05505c641f5df7abfae1021fcd16d1"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqry-lsp-linux-arm64"
        sha256 "17a96b6bb4299f5dd769b12ec7a992d0c85c8155ad8c0713b0e6f8483c74cd86"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v23.0.2/sqryd-linux-arm64"
        sha256 "231f2c4bda6363c50ab143c695223a772c1ab34a9c914c01ae33022140b06d8b"
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
