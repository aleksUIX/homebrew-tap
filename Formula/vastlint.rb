class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.8.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.8.0/vastlint-macos-aarch64.tar.gz"
      sha256 "50cfbd08ea691090b6d2fdc6b01cdec0544cad35872b9b051d314b55f0de3d16"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.8.0/vastlint-macos-x86_64.tar.gz"
      sha256 "e04c86b52019cfc86f2b67ae752804efd99c7b97563e46e2dea726c45e732006"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.8.0/vastlint-linux-aarch64.tar.gz"
      sha256 "a325b754dbfb72ad081263282eea05279b5c71c691ce15afe5b0ef1ff9e9ee70"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.8.0/vastlint-linux-x86_64.tar.gz"
      sha256 "a97d0075d189a312f3ed18e07fdc406105a7eb5144e9dbc6231f9e3e352f7d4f"
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
