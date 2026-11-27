class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.4"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.19.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint-tools/releases/download/cli-v0.19.0/vastlint-macos-aarch64.tar.gz"
      sha256 "18f9d07cd0bbb0f21737bdd6df3fe5057024bceaa38baebfe707539a6e750364"
    else
      url "https://github.com/aleksUIX/vastlint-tools/releases/download/cli-v0.19.0/vastlint-macos-x86_64.tar.gz"
      sha256 "31cdefb461728abbfd7c6dec494b9102ac1e2cc9704b567b2aa87dd363171fa8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint-tools/releases/download/cli-v0.19.0/vastlint-linux-aarch64.tar.gz"
      sha256 "6735aa19e15c829f7de92c5c01f005ee7331aede50d31d72dbf8e798521f0792"
    else
      url "https://github.com/aleksUIX/vastlint-tools/releases/download/cli-v0.19.0/vastlint-linux-x86_64.tar.gz"
      sha256 "a56b26836fb19c87fe3c948d7d5c562d8ee0b2962b10beaaeb731c9478de333e"
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
