class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.5.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.5.0/vastlint-macos-aarch64.tar.gz"
      sha256 "1771a31f7e78e2daba812d717523760bbfa4d92d0e5dc745923a18842c84cda5"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.5.0/vastlint-macos-x86_64.tar.gz"
      sha256 "3503cf50cdb263f369cbe2a1eadae13bd304964dc3ae260e6e232730d51a1fc4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.5.0/vastlint-linux-aarch64.tar.gz"
      sha256 "fd071e7c29cb935a6f25aea3e3e3be6c5a308ebe4a08e2e8c33dc86445ee007b"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.5.0/vastlint-linux-x86_64.tar.gz"
      sha256 "c0483e50d5b55cee942496aa37ba94b0713dfc2a885a70bc68a646ab1722704d"
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
