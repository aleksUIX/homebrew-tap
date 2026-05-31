class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.4.19"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.19/vastlint-macos-aarch64.tar.gz"
      sha256 "63dcb07b0f1f087c169abba5c9ee9765052e6d3f64a46e2f3b7860b03f78a223"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.19/vastlint-macos-x86_64.tar.gz"
      sha256 "4935fb97841bff2bf2b2282d1403cd92872e705fb06c0d514580504dcdba9a41"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.19/vastlint-linux-aarch64.tar.gz"
      sha256 "e821ea44458db7ba809f1ff7903c9db35d329d852110e0dc936e488a970c95f1"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.19/vastlint-linux-x86_64.tar.gz"
      sha256 "0c04fad6700ce98e82b0e2102f00c7dda4d2ae1629e4fe8dbdd6dfb1732674a9"
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
