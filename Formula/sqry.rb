class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "30.0.0"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqry-macos-arm64"
        sha256 "0ba76ed1058f2bcc61f2bbfa15b6f1e5720e65013549f9c15e01150e2819d088"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqry-mcp-macos-arm64"
        sha256 "f173ab05055530074505b4c42e4365c3d967301b62eb2112fb0e00cd9e9527ea"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqry-lsp-macos-arm64"
        sha256 "1ccaa71909d1a46619e7d872cb0a0c19a58dc28f1fd94a8a0cb3adb39f789d67"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqryd-macos-arm64"
        sha256 "49b378df7355b98999ebe511a5111dc4fdd5e72d4296d7c8ce8e6fce571d8b0f"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqry-macos-x86_64"
        sha256 "a66a5e3331b8fa24c79c64361d98397d8df0ffb1d94a16b4e1b9dcb89537e614"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqry-mcp-macos-x86_64"
        sha256 "e9a2352db934cd92a798f1af9109f0cfccb7764187557c68513397ad5177ff08"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqry-lsp-macos-x86_64"
        sha256 "0f8a1c980dbf3c0025736513e8dfade8c9ae11e2abff24fbb9f9d1bd2781ea7a"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqryd-macos-x86_64"
        sha256 "692bd2cd589d15baf4b51e0398ac1986ebc198194f54792b8e33b0e32a60bd75"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqry-linux-x86_64"
        sha256 "2e08f750bedd8e821bf70e743c7e4f159e47bcdca7d3b369632ff3c4cbc8dbe6"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqry-mcp-linux-x86_64"
        sha256 "f2ad0a55e10337dacc6dcab0fafed8e7fc899ee4f596785bf53aa8eaca04a357"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqry-lsp-linux-x86_64"
        sha256 "9cbb207ea1ef9c9dc564b529308afd1198adaaef6a2a5e4d3cb053d0a4221225"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqryd-linux-x86_64"
        sha256 "5ded68794382d7fe2e50698a7e382e91650cbf4d467aa17c6bd6dcfc2b968872"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqry-linux-arm64"
        sha256 "1f7affbfd1deefadda89f37508ba5403d9aa4050a59157c2df970d109e0ec244"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqry-mcp-linux-arm64"
        sha256 "8629d8d33d56d4b1d2df710bf71fa66d480bad821586a34d3b09a4fe32ab92a9"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqry-lsp-linux-arm64"
        sha256 "e507d8d551a2e36475d28efa044fb57ad5f0347389e70b091d7df1eec062434c"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v30.0.0/sqryd-linux-arm64"
        sha256 "99939b6e85fba3f7f6ae4623a2321ba1365788666458c60d2bf03f8b52ce1ad3"
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
