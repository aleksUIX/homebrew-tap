class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.10.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.10.1/vastlint-macos-aarch64.tar.gz"
      sha256 "92f41eb83697877935b360a7907ef33e1e6a8da12e14ba46ff4575daace6b140"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.10.1/vastlint-macos-x86_64.tar.gz"
      sha256 "beebc44aa080f38033fb4b49ae6616f92f48f676fee7ef2fc503cb28bb4f346c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.10.1/vastlint-linux-aarch64.tar.gz"
      sha256 "c9ee05592edbd99158745e1b4c541b186f9ac49263e26468c14360c8091473bf"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.10.1/vastlint-linux-x86_64.tar.gz"
      sha256 "f03e77a18a0177aaba0bb92b39cf55e0beb08a72cef2a48f8342a7db96e0a7bd"
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
