class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.4.21"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.21/vastlint-macos-aarch64.tar.gz"
      sha256 "ec85536cc121368512cdabf98244e544caf7a5ffc98cacd92c44492e72f7d846"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.21/vastlint-macos-x86_64.tar.gz"
      sha256 "a4d292c6d827fdc3857ba558fac846f4203a196a9a66602b6b3466292e0857f3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.21/vastlint-linux-aarch64.tar.gz"
      sha256 "ff7483e1817c1893301e0932c1fe1ed82d817233f6e884a9d4dcdbcef0210003"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.21/vastlint-linux-x86_64.tar.gz"
      sha256 "5536e7e2938852b6cbd7ee4158c885c33271e013ef541a4e67e4b36a7f62bc11"
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
