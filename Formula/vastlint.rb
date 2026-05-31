class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.4.20"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.20/vastlint-macos-aarch64.tar.gz"
      sha256 "ff42b51bbfbe714256952fcc6b567f36f00c48d25b71af105a0c995098c964ce"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.20/vastlint-macos-x86_64.tar.gz"
      sha256 "776cae7091587d6d7903b6cda9007dcd2c4cecc4f881eecc7ab77f24d52a4528"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.20/vastlint-linux-aarch64.tar.gz"
      sha256 "de6a7778a0f96d5d1a8e9d83c989df9e7b34e1d1a5256e38fa3036b97d643f79"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.20/vastlint-linux-x86_64.tar.gz"
      sha256 "f062de43131d436b40172c22d20bea8973da302b417b697a94aeee47c7372408"
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
