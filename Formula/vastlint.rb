class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.4.14"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.14/vastlint-macos-aarch64.tar.gz"
      sha256 "02ea85e360b2d64fd6a84358c89033c599672defa1d5d9cb145eebe8b754304f"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.14/vastlint-macos-x86_64.tar.gz"
      sha256 "75f59bdfc14b1ec24a43556c684a9a0cca9abab676c96f0b6f2c9c15a7311422"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.14/vastlint-linux-aarch64.tar.gz"
      sha256 "b445ac9d031286ed21e7c70b6b4e2d776288e5e91ef6d3d81b34007a83008e39"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.14/vastlint-linux-x86_64.tar.gz"
      sha256 "a30822e0b60f91be60a247f026c3011cec4b8cfcc21dc8508e67f650f678ed6c"
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
