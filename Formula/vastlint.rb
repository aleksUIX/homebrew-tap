class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.4"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.13.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.13.4/vastlint-macos-aarch64.tar.gz"
      sha256 "729d5ddd9ba8e2b078a776ff2c97a01181b38dafa248283678995d717f6214e2"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.13.4/vastlint-macos-x86_64.tar.gz"
      sha256 "5ddf830acd352cbfc1c3831d49a26b8fced6c490b93175860d8cd61c82aebef9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.13.4/vastlint-linux-aarch64.tar.gz"
      sha256 "e4cf09b898929fead403f404d3880c6d8fd718a4ef6c5a7e78a777edf20754aa"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.13.4/vastlint-linux-x86_64.tar.gz"
      sha256 "85b249b79e5dd7d59af4c3e6844224b20257f35d453099504ce110f4c1ae1ba2"
    end
  end

  def install
    bin.install "vastlint"
  end

  test do
    # Minimal valid VAST 2.0. Named values rather than placeholders: the quality
    # rules flag "Test" as an AdSystem, and a Linear with no quartile trackers
    # is a warning, so the old sample printed findings and never matched.
    (testpath/"test.xml").write <<~XML
      <VAST version="2.0">
        <Ad>
          <InLine>
            <AdSystem version="1.0">ExampleAdServer</AdSystem>
            <AdTitle>Acme Spring Sale 30s</AdTitle>
            <Impression><![CDATA[https://example.com/pixel]]></Impression>
            <Creatives>
              <Creative>
                <Linear>
                  <Duration>00:00:30</Duration>
                  <TrackingEvents>
                    <Tracking event="start"><![CDATA[https://example.com/start]]></Tracking>
                    <Tracking event="firstQuartile"><![CDATA[https://example.com/q1]]></Tracking>
                    <Tracking event="midpoint"><![CDATA[https://example.com/q2]]></Tracking>
                    <Tracking event="thirdQuartile"><![CDATA[https://example.com/q3]]></Tracking>
                    <Tracking event="complete"><![CDATA[https://example.com/complete]]></Tracking>
                  </TrackingEvents>
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
    assert_match version.to_s, shell_output("#{bin}/vastlint --version")
  end
end
