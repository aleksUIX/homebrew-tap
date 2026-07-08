class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.8.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.8.1/vastlint-macos-aarch64.tar.gz"
      sha256 "cee44c9b37ae6e159fe6dfe5c45726947ec9447095fca7cb469e382061e79761"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.8.1/vastlint-macos-x86_64.tar.gz"
      sha256 "dab638fbc9474ffaa109b51837b0867d2fd90b6e2110bf1fc4be7dd6a755ca49"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.8.1/vastlint-linux-aarch64.tar.gz"
      sha256 "5b77bbc3f35f33d3c70fcde1bec7a4ab4000221d184403739e9c3cef38de81b9"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.8.1/vastlint-linux-x86_64.tar.gz"
      sha256 "dc5a66e49448e4c07586378a2ca8781b397921819b3cea760478b32826cf968d"
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
