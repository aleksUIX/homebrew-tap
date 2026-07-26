class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.10.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.10.0/vastlint-macos-aarch64.tar.gz"
      sha256 "e2affc5d3239115a3e6d01f7d2e30f9bf19f3c93c4674da1689fb317219dbffa"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.10.0/vastlint-macos-x86_64.tar.gz"
      sha256 "8ef9eef19de34e9cf484479f2e6abd1466aa4727e2e95bbe2f04794c22eac4ee"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.10.0/vastlint-linux-aarch64.tar.gz"
      sha256 "3bbcc672b8e1830cab8bfaa1cdf89b2955ad2d9cc2f69720a8b39a18fc18bc92"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.10.0/vastlint-linux-x86_64.tar.gz"
      sha256 "121b6da3e1abc89413eb77f5593a2eaae5263d90a1f995d3a1f7a7d2425bb40e"
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
