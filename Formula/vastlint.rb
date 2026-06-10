class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.4.24"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.24/vastlint-macos-aarch64.tar.gz"
      sha256 "49f09f05f72600288928694b7d8c24a8d9e3fbb442ea85b755768bc0c8d1a669"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.24/vastlint-macos-x86_64.tar.gz"
      sha256 "53eb9f8fbed5e75e4891e13bd1f295a5ebadeb87812e2032f28f9c1bd42037e4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.24/vastlint-linux-aarch64.tar.gz"
      sha256 "b76473aab5df5d94209336b463adb26ea2fef8a8a39d861a48053290a8245da5"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.24/vastlint-linux-x86_64.tar.gz"
      sha256 "feca9c80181f9f9aa845e05a43eceb640c8928faacc2d76f7e370299986df901"
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
