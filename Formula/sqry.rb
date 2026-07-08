class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "28.0.3"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqry-macos-arm64"
        sha256 "f9107382152de729fcf45e652756ad1ca1596d3296ca5b6aa3af4cb098b9fe69"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqry-mcp-macos-arm64"
        sha256 "9fded57120b89a4ddb66b6e248eb88c458b58d314f75045768d42e189a496297"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqry-lsp-macos-arm64"
        sha256 "59759ab77346522bbe32ef9f2c1c0cb034606af2a664a05dfca5fa022fbf3358"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqryd-macos-arm64"
        sha256 "622502272aa39e4aa033a34fdfe53823916f93e0f8fe6f00ccbf0d97e2da4ab6"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqry-macos-x86_64"
        sha256 "972da1bf7e4852f80ea0aa758e0df3fa892dc8eea035c84e29e40a6e12e0496c"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqry-mcp-macos-x86_64"
        sha256 "8e750c377d04d5a6c9fc140a97d63a15af27506172cc83eeb395426c96d738b8"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqry-lsp-macos-x86_64"
        sha256 "a21d354d54f7647348cf859f5e621749246729fe11f25ffc51a505c9b3c92cdb"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqryd-macos-x86_64"
        sha256 "36c995fc576eedf342be0b1e2e10dd54a6a23e741f07a1e6d9642baa6f58df89"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqry-linux-x86_64"
        sha256 "5dd949f52b442366cb4e7b00203aab6bbdf1651a106e0f38db0f05a6fd70a846"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqry-mcp-linux-x86_64"
        sha256 "52a35a42a65251dc79cf913fe972c404b97efbf780427638bcdba062093d91ad"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqry-lsp-linux-x86_64"
        sha256 "ccb697f3397ebe27580f8144931df75c5bf6db677784123812e944454aee9ffc"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqryd-linux-x86_64"
        sha256 "d4672a13127b7fc41bcd5b55b882dc7b1fabb29aec2587d2130727b05ef2271e"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqry-linux-arm64"
        sha256 "3764bcd512d5b1a72fc72fe06ba0170f5e78f45eced3663e52b3e649df899fc3"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqry-mcp-linux-arm64"
        sha256 "3dda43f855ec75e1dc71f25e8221d3cea1f7f0c58bc08291a3f8e4a1477ffd74"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqry-lsp-linux-arm64"
        sha256 "936260bfbcd807759a40131fc74e260c20c2e947484dcdeac578041173f0570a"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v28.0.3/sqryd-linux-arm64"
        sha256 "8cb6d65be5a1230e61c422da47165e5e48875f49ebacdbdc966f684495672e1e"
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
