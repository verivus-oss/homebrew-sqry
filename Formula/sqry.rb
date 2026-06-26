class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "22.0.4"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqry-macos-arm64"
        sha256 "7d5fe4a7cdf18b54b8a1d9ddd21ae00af02462b1e24f7699e946e00d6afb5846"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqry-mcp-macos-arm64"
        sha256 "91d28e926557adf601557be976228f8d741d455179ef0266d87d607892797306"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqry-lsp-macos-arm64"
        sha256 "364cf637af544e216cc234268e1bc095d807ba0f904fd57699f439f770fd4604"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqryd-macos-arm64"
        sha256 "3d161020ee0b35de8303662e50c55c73b5d93b4648374bf3ad56a6226bdd36bf"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqry-macos-x86_64"
        sha256 "8deef16d996e89bdb825e43142ad22c5e81609c3cdeedee77ad6fed3c0494435"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqry-mcp-macos-x86_64"
        sha256 "59a4641aa72c9be439f0f53d20f6473689b0beda194917e0e9fef7303a5a3cd9"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqry-lsp-macos-x86_64"
        sha256 "9d8d15ee48fa1208416aab1260d2ed611cdb1f26915f90b13fab7351814284f4"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqryd-macos-x86_64"
        sha256 "c8a9d4732776a1cf0aaf62c90da5251d8dc8f9c7c8dd085a5c3726f64ce20943"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqry-linux-x86_64"
        sha256 "6a1682d554cd9602f7273780bc5e77b2e08ca4f897eacb2f96e0dc9d91934027"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqry-mcp-linux-x86_64"
        sha256 "bd06f93d4c07fb17165fae018a04144a6ca48e82be768d52dc59596f29a9f604"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqry-lsp-linux-x86_64"
        sha256 "5952bcc173fe5a54a7107c012437e4f8252d7c51ac9bffc1811c4db3b5113d81"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqryd-linux-x86_64"
        sha256 "a9c7032f0255acad4afa60d683a85b4f6502dec0ff45112cc0fd8cf2023a5cfd"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqry-linux-arm64"
        sha256 "b24235cff38f91a645d1a33fe185131a8a6a4353c5ab6ddf28096d0a42c6e3da"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqry-mcp-linux-arm64"
        sha256 "934a28b5642ae40742c0f187876e0dd40d9620e1478e9e33db4968ad82ad3573"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqry-lsp-linux-arm64"
        sha256 "c376e171384c35edc605edd2f1b1afb850c1057e36c271d6a781158375f1d31d"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v22.0.4/sqryd-linux-arm64"
        sha256 "5d691da1324d20981a29cdd6f8e45a3fe316a6c01efab6627ea6cdda92a72d63"
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
