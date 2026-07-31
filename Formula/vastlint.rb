class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.11.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.11.1/vastlint-macos-aarch64.tar.gz"
      sha256 "3e818c1147475050d762b662c87ec54d0c2b8fc97189f07173c831e582cdbb22"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.11.1/vastlint-macos-x86_64.tar.gz"
      sha256 "74d0049958a5c3b0d5240f50df11c6babb09fecb5c829f7177b3a747a2131099"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.11.1/vastlint-linux-aarch64.tar.gz"
      sha256 "3763f23bb4342f439bd8d12ce3d26ce2fd8bb30e6090f10bbd95d18070117262"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.11.1/vastlint-linux-x86_64.tar.gz"
      sha256 "0556b84b274a43b78db37033a0f3de426d80c220ec1fb5532c0bfa4e02b10c5a"
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
