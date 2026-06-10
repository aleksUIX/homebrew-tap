class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.4.23"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.23/vastlint-macos-aarch64.tar.gz"
      sha256 "9e21f1aadeaa27a08b747a22f1b17b5312f66aa1830c2ab2f3a9042eba6ce3f4"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.23/vastlint-macos-x86_64.tar.gz"
      sha256 "968f968b31b16f0513df3d4e546725f6ad60df00721241e5e3050eed456801f1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.23/vastlint-linux-aarch64.tar.gz"
      sha256 "4956525866cbc9a45bb211a0f92cf52093cfef767baff03d43e70b9747564ed9"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.23/vastlint-linux-x86_64.tar.gz"
      sha256 "b495a740a32e08bccd5112bab34296ea93366922d3cb8a8e7f2d00e39ddd37e7"
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
