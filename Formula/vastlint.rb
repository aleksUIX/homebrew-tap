class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.6.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.3/vastlint-macos-aarch64.tar.gz"
      sha256 "20d7bd3ea261468dcd1aa000bd54245941de64ed31b78fe05790dc87e4a54300"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.3/vastlint-macos-x86_64.tar.gz"
      sha256 "21b761da3085c71b97abd347a6d3e791b195677a8c76899914dd73bef65ba0de"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.3/vastlint-linux-aarch64.tar.gz"
      sha256 "fc2c3f47850b361292506999fde1b28648923482cbc51182374caffdd7ee051f"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.3/vastlint-linux-x86_64.tar.gz"
      sha256 "5987650e2bc74c036d69e06f80c105400beceed4e8538ecfeff5e1af6ba89134"
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
