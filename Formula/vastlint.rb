class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.4"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.13.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.13.2/vastlint-macos-aarch64.tar.gz"
      sha256 "c5195f228d78c4225360719130aaf92a6f04356cdc37c6cc10c596faee1a6ed8"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.13.2/vastlint-macos-x86_64.tar.gz"
      sha256 "3877db87dc49c97c3b9796d855d78da5713d2203581b91ff1809498039975b71"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.13.2/vastlint-linux-aarch64.tar.gz"
      sha256 "fd11441ab2a45d4ca10e26ef88f4e5958c599210100771452501f3e71af2339a"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.13.2/vastlint-linux-x86_64.tar.gz"
      sha256 "c2da28099937c93b120c981b7da0e211db04d23e9458c72bf413445aa14391dc"
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
