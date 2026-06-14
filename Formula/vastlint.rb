class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.5.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.5.0/vastlint-macos-aarch64.tar.gz"
      sha256 "75bb1690d68f253a49ced02c2103401977a4349be26816d0d483a936ed67bdfb"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.5.0/vastlint-macos-x86_64.tar.gz"
      sha256 "bf6d536b28700d631f073b6e623c5e0265c380cf758a93b65f8f2d68dbcac571"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.5.0/vastlint-linux-aarch64.tar.gz"
      sha256 "d2de2b1a89338625492429911b33404b54183ff3ef24eb2e05eb050542190994"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.5.0/vastlint-linux-x86_64.tar.gz"
      sha256 "43e98cb37e459074de6ef62ecf5f18e3219f2c005a4c5979c9e255dbeacf2490"
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
