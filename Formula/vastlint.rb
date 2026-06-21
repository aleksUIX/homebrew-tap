class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.6.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.2/vastlint-macos-aarch64.tar.gz"
      sha256 "077414384f33e7682f229e00588ef2e5eca79395ccc166b750a79a4242dd48bb"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.2/vastlint-macos-x86_64.tar.gz"
      sha256 "925333b66d9544e67c9052f31e0af4e736bec34c93e14edf5ea2a4abf348ccbf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.2/vastlint-linux-aarch64.tar.gz"
      sha256 "66519225aa21402ba9f9aed37db457d99f70e027f911f0427e2288ec474f298f"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.2/vastlint-linux-x86_64.tar.gz"
      sha256 "9c2883b2a139b1285b7c08cba3d64ccfe292bbb4d4ebb7ddb75170ae6e57e979"
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
