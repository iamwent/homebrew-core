class Kottie < Formula
  desc "Cli tool based on Koltin Native to convert your Lottie JSON to dotLottie format"
  homepage "https://github.com/iamwent/kottie"
  url "https://github.com/iamwent/kottie/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "51cecb0c25e2325c8863049502eef0efdaa39ef6d96e2226d95168a2b6a40818"
  license "Apache-2.0"
  head "https://github.com/iamwent/kottie.git", branch: "main"

  depends_on "gradle" => :build
  depends_on "openjdk" => :build
  depends_on xcode: ["12.5", :build]
  depends_on :macos
  uses_from_macos "curl"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    mac_suffix = Hardware::CPU.intel? ? "X64" : Hardware::CPU.arch.to_s.capitalize
    build_task = "linkReleaseExecutableMacos#{mac_suffix}"
    system "gradle", "clean", build_task
    bin.install "build/bin/macos#{mac_suffix}/releaseExecutable/kottie.kexe" => "kottie"
  end

  test do
    # output = shell_output(bin/"kottie")
    output = shell_output("#{bin}/kottie")
    assert_match "Find lottie files...", output
  end
end
