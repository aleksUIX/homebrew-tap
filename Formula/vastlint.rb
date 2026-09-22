class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.4"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.13.10"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.13.10/vastlint-macos-aarch64.tar.gz"
      sha256 "f256cbdc99e7b6355f3fca3d72450b2c4e04ff97a3bc9fd1ba2a020f94bd8aa9"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.13.10/vastlint-macos-x86_64.tar.gz"
      sha256 "db2136a128fbece6893762967a3a3d5d74717990129ae8b28d02cfb41451450c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.13.10/vastlint-linux-aarch64.tar.gz"
      sha256 "1166ca44ec0668db6507c4d9d0c5d596d06e35e6d460d1ca59f3423dc5693255"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.13.10/vastlint-linux-x86_64.tar.gz"
      sha256 "61b16fec4e097e733c9f08382c5cae883fb88155166e3c13fc9802898a15126a"
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
