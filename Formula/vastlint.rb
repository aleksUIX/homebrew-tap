class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.4.18"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.18/vastlint-macos-aarch64.tar.gz"
      sha256 "a3a9ee628287cef22ae6dd5f941fafca48fef6d4e6eb4cf60fd1f39e852bd7e5"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.18/vastlint-macos-x86_64.tar.gz"
      sha256 "a348d51f3d817501c6cdb3572076b04ef0e4f477084e6a01c46bd0ac7c294c44"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.18/vastlint-linux-aarch64.tar.gz"
      sha256 "5ce4d1d7678967a76f0777144c7d2a0f1661eb6a5be094c426d16f714b369cfb"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.18/vastlint-linux-x86_64.tar.gz"
      sha256 "54ff4152595ff09580c46ef608053136dac5737d3374e46f7bb85bf934a52927"
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
