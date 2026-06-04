class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "19.0.4"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqry-macos-arm64"
        sha256 "4858f454a2a6b9fafabd59ebc9d830b38508bdc5f5da29fd90ec70f4d0392e7e"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqry-mcp-macos-arm64"
        sha256 "843f1fdc76a6fa61629906f98087715cc73a02b8a298907710d1d31c1240237b"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqry-lsp-macos-arm64"
        sha256 "598e93b21d076370342cfc0452eca7f9258695ea7d27507919e1594fd0391a12"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqryd-macos-arm64"
        sha256 "27a3086d5e8d3f5916806b4424164597652ff81dea67e966f4aedc0c5a15c7f7"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqry-macos-x86_64"
        sha256 "9b59422a48a34148d5a40b9273ba81344dd209abaa312904b74a169d41534d76"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqry-mcp-macos-x86_64"
        sha256 "86b6d6856ff2658d65490ae1c70ca2818667a2bffbb97820c967b5ebcad35ad4"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqry-lsp-macos-x86_64"
        sha256 "a615a7f82cbf2a049dd86b8572d6541294a38fa72a4885ce627aadf4944c1358"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqryd-macos-x86_64"
        sha256 "7f39ee287056d3930c6e1485ae4429476cf46787a2dc40802e68683342459dea"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqry-linux-x86_64"
        sha256 "92c9f91df5806d4fdaba3aea9ee7a29c92fca995a7f96fb5f552c856836b5fc4"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqry-mcp-linux-x86_64"
        sha256 "05f6e738cd33c9bc8cfbe8f30e10e5e78154719a12ad3022510f56989b74042d"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqry-lsp-linux-x86_64"
        sha256 "93036bd317710304b287d129660f3427f3c0b8688a5747e0fa43302a8ce29bdb"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqryd-linux-x86_64"
        sha256 "d6bc8e0f9e86b8d44c03e0a8c564edc50a874e8cc63b76cfaac375a4bd1a2149"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqry-linux-arm64"
        sha256 "847b243dd44e7e9b97ee4691fc08073af4e02dcc0f2390aae61e4050e1dc721b"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqry-mcp-linux-arm64"
        sha256 "4de3dc2294a22cbdadece4240c90c539b82d7602453ed4908b262f78702ce822"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqry-lsp-linux-arm64"
        sha256 "b5f5e884ca89e69b1f4478f9d035d0130dcc2443971412fff58d2bbbaa72db6e"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v19.0.4/sqryd-linux-arm64"
        sha256 "f36fddf76ae2eb16f5c751291a33dca29202973fb173ce39d85104b3de027e9a"
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
