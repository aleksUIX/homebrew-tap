class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.6.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.1/vastlint-macos-aarch64.tar.gz"
      sha256 "e084f317c6c11bc311969a6e9651370b7c50963a4b2c93eac4bfa0647f8e9a8d"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.1/vastlint-macos-x86_64.tar.gz"
      sha256 "17a1a43a2a8aa8d27d10dd3fb00ae885d72300efe45f17a29bf0d29146606925"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.1/vastlint-linux-aarch64.tar.gz"
      sha256 "794a05325423a3fa6d0e9463b1db4efcd3b09232cf1ff53ade06baef49645df2"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.1/vastlint-linux-x86_64.tar.gz"
      sha256 "7dac893daa92896a493c367cb5dc14dc26583545506bbe9ed38f190868a5874f"
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
