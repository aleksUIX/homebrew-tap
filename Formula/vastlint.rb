class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.9.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.9.0/vastlint-macos-aarch64.tar.gz"
      sha256 "c0534e713b277ba4ecbb2b572dd02c313137a0d50fa7eef3467e8162304da90d"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.9.0/vastlint-macos-x86_64.tar.gz"
      sha256 "8bb1f354aa9b8a5b17f7d43f75ebb620b398fc47018ab209aefd7cf5d6d2f5d8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.9.0/vastlint-linux-aarch64.tar.gz"
      sha256 "17cb861a5a235657259a8de819a4bae43821160576246917ad202ac113cf80a4"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.9.0/vastlint-linux-x86_64.tar.gz"
      sha256 "8c0a3c8475887f3cf7b0d535e1fba1a614f5a476accab605acf115542f39aa55"
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
