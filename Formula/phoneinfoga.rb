class Phoneinfoga < Formula
  desc "Information gathering framework for phone numbers"
  homepage "https://sundowndev.github.io/phoneinfoga/"
  license "GPL-3.0-only"
  head "https://github.com/sundowndev/phoneinfoga.git", branch: "master"

  stable do
    url "https://github.com/sundowndev/phoneinfoga/archive/v2.10.7.tar.gz"
    sha256 "14dc41ec4a2c3f8a97e4ea7bf99736e94a94b2e04b36075171f482a6f0873127"

    # patch to build with node v20, remove in next release
    patch do
      url "https://github.com/sundowndev/phoneinfoga/commit/ad3a393192963b53318e5cb749ce85d7e651caca.patch?full_index=1"
      sha256 "f8fcd2fed13e5faab0aaa4e94d69bfbd33131e86b9cfa66368bbe2d43a6035cd"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ee2752bc0b93e1d38dfc435ad74d0c6bb721fc299f80f49a36413178b8f0cd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "120e0da24bf2635d57fddcfb8d1db5fb4eed919368f5c6a504468130e257f214"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "884a8b5c95df874977b5918060c938b9420e81ab18ca76874191a1ded0b7d29b"
    sha256 cellar: :any_skip_relocation, ventura:        "eb4d9594ec3cc0f6c23d0579f05c5f6810ee5fc6ea51bc8220649974ed248da3"
    sha256 cellar: :any_skip_relocation, monterey:       "b8f489c703312c268aa78febd4bc2c923805b6d10116efa7cb5067661c561841"
    sha256 cellar: :any_skip_relocation, big_sur:        "f79b25515c22984439c36cc3022e53550976259df3908b800866d800812e7525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e227b3dc433024b2a48d074427ec20e3762608f2bb4d2cd41e1274e5c53834a0"
  end

  depends_on "go" => :build
  depends_on "yarn" => :build
  depends_on "node"

  def install
    cd "web/client" do
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/sundowndev/phoneinfoga/v2/build.Version=v#{version}
      -X github.com/sundowndev/phoneinfoga/v2/build.Commit=brew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "PhoneInfoga v#{version}-brew", shell_output("#{bin}/phoneinfoga version")
    system "#{bin}/phoneinfoga", "scanners"
    assert_match "given phone number is not valid", shell_output("#{bin}/phoneinfoga scan -n foobar 2>&1", 1)
  end
end
