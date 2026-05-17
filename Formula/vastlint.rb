class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.4.17"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.17/vastlint-macos-aarch64.tar.gz"
      sha256 "9b0befa6e5544eb4ae00732cb919caa8b2e4a4327cb4804d7f93d4f32c39438f"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.17/vastlint-macos-x86_64.tar.gz"
      sha256 "ccfba4a91db2d7092bd5138a9b92f0daf0a151c51b9603672a3591a2d3718744"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.17/vastlint-linux-aarch64.tar.gz"
      sha256 "feb2e9ea4e85efdb1b852d686aacfc6ca0f4e3a7924f35f15d3418f4360d1d8b"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.17/vastlint-linux-x86_64.tar.gz"
      sha256 "d5ddf6ddec2e6d33214bf7946c62e1eb3177b509f53a77e4177de1c82c79d96d"
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
