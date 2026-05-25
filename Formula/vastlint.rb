class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.4.18"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.18/vastlint-macos-aarch64.tar.gz"
      sha256 "5a6cc14c779103c14cea27217dca3a4938378bb88a1ec4a187a34709f40da305"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.18/vastlint-macos-x86_64.tar.gz"
      sha256 "b4fe84bd7570bd84f289300490732c6ef0b13c6191b9f4dc25b0874a47188558"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.18/vastlint-linux-aarch64.tar.gz"
      sha256 "bf9154c33d1b3d7e9a2beb2e9e8315a81d5f5399479ddea40344c64804699515"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.18/vastlint-linux-x86_64.tar.gz"
      sha256 "0f5d792b8bad8ba453a9f36a636818667cb89d40207cfac57e95bb0bb08a224d"
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
