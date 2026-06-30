class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.7.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.7.1/vastlint-macos-aarch64.tar.gz"
      sha256 "a61d8af3847368eb2f4d010fb3288265e0d723c838a31f9ecb70521702f6f2b5"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.7.1/vastlint-macos-x86_64.tar.gz"
      sha256 "9c9a210d1083eb3fe6043e461d56d8d3b189557b3d7f37d5b7495b439bd313fb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.7.1/vastlint-linux-aarch64.tar.gz"
      sha256 "cf48f95deb1f2b545f61c5b1daba51e1db2d3af330957c823c7add9b8220a634"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.7.1/vastlint-linux-x86_64.tar.gz"
      sha256 "720cfca501276299a8f1aa9c3383829a02ff8828b5f0d658b3b520cf15dd4701"
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
