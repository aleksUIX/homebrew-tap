class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.6.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.0/vastlint-macos-aarch64.tar.gz"
      sha256 "7881ed233af0db51d48b3fdb3cc277c7efd269fdcbcafac54f1aac2202a74f0b"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.0/vastlint-macos-x86_64.tar.gz"
      sha256 "1ebabdce958bbfabbc779d68a2b7808d950afac5e53f447e6002402d6718f06f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.0/vastlint-linux-aarch64.tar.gz"
      sha256 "91aae885bee05c2a6f1ae5ff23467c58fd15324988148f3fa5804e4d24706194"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.6.0/vastlint-linux-x86_64.tar.gz"
      sha256 "8a24015ef8b9cfbcf8d5f65bf29e829ebd9694fc9a9c2f995b3f90abd73b669d"
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
