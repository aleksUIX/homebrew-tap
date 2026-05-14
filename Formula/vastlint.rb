class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.4.15"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.15/vastlint-macos-aarch64.tar.gz"
      sha256 "2b746d80c217c23edfefa2b298bd66096ed53b216400e262125ab1c8ef6c2c92"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.15/vastlint-macos-x86_64.tar.gz"
      sha256 "ab1bac48ee6494934b7e1823a3bc7fa2031f6276c7d17ea785fea0c0883e0a78"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.15/vastlint-linux-aarch64.tar.gz"
      sha256 "cf2372a87d69c1356de75794d2633e594521c200b5f92222c6ddbfa1cd6114fe"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.15/vastlint-linux-x86_64.tar.gz"
      sha256 "28f69e5dd484d2f838adbb8e01dc1a0ecc57ce5299758b8abd4667f79c84b2bd"
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
