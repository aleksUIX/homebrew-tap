class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.7.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.7.2/vastlint-macos-aarch64.tar.gz"
      sha256 "4b52165eb4d986c8b457eb09cc2489cf9cf151e5926d8422ff5c92e94ccceec2"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.7.2/vastlint-macos-x86_64.tar.gz"
      sha256 "74a991b66206170054f3d387e4afa639d90115e8d54916f78963c8ec924a6505"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.7.2/vastlint-linux-aarch64.tar.gz"
      sha256 "9479856746458587567fe1bb6d91c7dc890e4640726b9a8754a97f7bc6ce1b64"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.7.2/vastlint-linux-x86_64.tar.gz"
      sha256 "3557775d55787b765b612680a94d086f6321ed956f7130bd293879798d2c5092"
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
