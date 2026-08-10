class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.4"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.11.8"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.11.8/vastlint-macos-aarch64.tar.gz"
      sha256 "95e185e76aaa9410bc86b2acfcf9f0b47393ae4ac6c8690286936f36b574a25a"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.11.8/vastlint-macos-x86_64.tar.gz"
      sha256 "9e1da3c2c8d2b5d297fc24563d6e3184e3e78164daf6f319afdd039407cb10f1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.11.8/vastlint-linux-aarch64.tar.gz"
      sha256 "2917659d54a6eb6af08eda297e33b9282aed189a0004c9707cf601930ad3d6f8"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.11.8/vastlint-linux-x86_64.tar.gz"
      sha256 "cd006835d4e263dd76e720579d6a2aca5e3e79b6ce319cbde4e5a57a8150ecf4"
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
