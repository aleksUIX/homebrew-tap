class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.10.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.10.2/vastlint-macos-aarch64.tar.gz"
      sha256 "8eb06ecd623e4bda27151f5979df8509aca4b6be09b3d70836d56c1782713bbd"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.10.2/vastlint-macos-x86_64.tar.gz"
      sha256 "e746a4a9b8062e324b99bacdb3115e5306f59058c89f158ae94e2759ea79047e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.10.2/vastlint-linux-aarch64.tar.gz"
      sha256 "7760a2950bb54c944637643d6c42f038ed51b51ae399b6ac47f903bfabb0c8b5"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.10.2/vastlint-linux-x86_64.tar.gz"
      sha256 "8a376d0a2b69bcbed3a87dfca2e5ab7918964f817a99068dc12c507cd8a4c469"
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
