class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "4.8.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/verivus-oss/sqry/releases/download/v4.8.16/sqry-macos-arm64"
      sha256 "9546b6fca9022aed546b87f7751f488dd3842a64a491ea2faf7936ca96f38a19"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/verivus-oss/sqry/releases/download/v4.8.16/sqry-linux-x86_64"
      sha256 "12b8bb6327c386804a7c21a303b5312a0d38640d12f46956b7926358e935f284"
    end

    on_arm do
      url "https://github.com/verivus-oss/sqry/releases/download/v4.8.16/sqry-linux-arm64"
      sha256 "6876d83b4974ceed8bb898a8f0eabc1f0eaf795a9523877058393968c526b3c2"
    end
  end

  def install
    binary_name = if OS.mac?
      "sqry-macos-arm64"
    elsif Hardware::CPU.arm?
      "sqry-linux-arm64"
    else
      "sqry-linux-x86_64"
    end

    chmod 0o755, binary_name
    bin.install binary_name => "sqry"
  end

  test do
    output = shell_output("#{bin}/sqry --version")
    assert_match version.to_s, output
  end
end
