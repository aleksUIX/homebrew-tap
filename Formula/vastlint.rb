class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.8.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.8.4/vastlint-macos-aarch64.tar.gz"
      sha256 "12f0b48b9545bb436fefb8e3b5f49f3ab016b57c2311da3dab0f95e653ab9905"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.8.4/vastlint-macos-x86_64.tar.gz"
      sha256 "796eacb1aab54ea9b8f4d15592d972ce0d4b309b3914675e6ef714de056b2172"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.8.4/vastlint-linux-aarch64.tar.gz"
      sha256 "5b794fa8b574adfcbcd90395c0fb1ecd8203106d27a039357e95f47a132f0c9b"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.8.4/vastlint-linux-x86_64.tar.gz"
      sha256 "41d01a5a2534db18ef9be22ca7264d0dc796f7831e991dae0dd391e337b6ddbf"
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
