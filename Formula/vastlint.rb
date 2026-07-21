class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.9.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.9.1/vastlint-macos-aarch64.tar.gz"
      sha256 "68de7ee6824e9365dfcf65601f24383c12e27124bd47a0669db680bc7ece40e3"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.9.1/vastlint-macos-x86_64.tar.gz"
      sha256 "a5f45c8a629134e083349da7a240f848a49ee8f813f2fd35bca7a27c05b503e2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.9.1/vastlint-linux-aarch64.tar.gz"
      sha256 "60ee5855b7f1b5e401f3ee413da204768da21f8260129dccbd20e02672a18b0e"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.9.1/vastlint-linux-x86_64.tar.gz"
      sha256 "0fc902e099f203c80c3329199dd22efddbcb3ed2fdd2902253baf0bee675512d"
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
