class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://github.com/aleksUIX/vastlint"
  license "Apache-2.0"
  version "0.1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.1.0/vastlint-macos-aarch64.tar.gz"
      sha256 "5890d57cbf680acd834e2ac7e27e56872a2e2b60edd56b18b8ddcd839338bc2e"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.1.0/vastlint-macos-x86_64.tar.gz"
      sha256 "38bfd6020e0039ec754d0b67a48d4748c36324b2a71ace87fcc56cf113a9552e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.1.0/vastlint-linux-aarch64.tar.gz"
      sha256 "ed638e052d5e6abebdc092efc46bee52bb8d4c4860c39220bd0f94c5f15b4c06"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.1.0/vastlint-linux-x86_64.tar.gz"
      sha256 "ab1e4f3bd6244d6ad60e14b10e03fcaa041b574c2f0944986416f9b7baa0f3a0"
    end
  end

  def install
    bin.install "vastlint"
  end

  test do
    # Minimal valid VAST 2.0
    (testpath/"test.xml").write <<~XML
      <VAST version="2.0">
        <Ad>
          <InLine>
            <AdSystem>Test</AdSystem>
            <AdTitle>Test Ad</AdTitle>
            <Impression><![CDATA[https://example.com/pixel]]></Impression>
            <Creatives>
              <Creative>
                <Linear>
                  <Duration>00:00:30</Duration>
                  <MediaFiles>
                    <MediaFile delivery="progressive" type="video/mp4" width="640" height="480">
                      <![CDATA[https://example.com/video.mp4]]>
                    </MediaFile>
                  </MediaFiles>
                </Linear>
              </Creative>
            </Creatives>
          </InLine>
        </Ad>
      </VAST>
    XML
    assert_match "no issues", shell_output("#{bin}/vastlint check #{testpath}/test.xml")
  end
end
