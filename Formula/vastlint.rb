class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.7.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.7.0/vastlint-macos-aarch64.tar.gz"
      sha256 "a234a2bc85cd4e026f7b578c24caab0f2a2690b01bd3081c8670f2052bd4d11e"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.7.0/vastlint-macos-x86_64.tar.gz"
      sha256 "8a17514d46511dabf8c13bdfdd234f9430ece5f0a1d8808d6425136daf51d653"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.7.0/vastlint-linux-aarch64.tar.gz"
      sha256 "1a46addb527f7959689338dc7c89af0616cd02a1f94f4471d02628b5c6679bde"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.7.0/vastlint-linux-x86_64.tar.gz"
      sha256 "e842158940926f3a23b20bd73fcb7278cf122a41749015a16e1a36675a271c43"
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
