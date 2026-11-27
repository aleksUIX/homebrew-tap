class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.4"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.18.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint-tools/releases/download/cli-v0.18.0/vastlint-macos-aarch64.tar.gz"
      sha256 "6ac790537dbf4ec238bed4469d6cff4d78f5297c66fadbc47f71c7789dce3d31"
    else
      url "https://github.com/aleksUIX/vastlint-tools/releases/download/cli-v0.18.0/vastlint-macos-x86_64.tar.gz"
      sha256 "fda4d45512095efcb4342d392988293e6460b379b04f5294b401cba89e5663d9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint-tools/releases/download/cli-v0.18.0/vastlint-linux-aarch64.tar.gz"
      sha256 "dd296dd124b1f976e46edb80cde7fe34eab62e7b1261047d445b7acdac6958aa"
    else
      url "https://github.com/aleksUIX/vastlint-tools/releases/download/cli-v0.18.0/vastlint-linux-x86_64.tar.gz"
      sha256 "2421088369039f6e06302ee853ec3ebd8342f5f44c65643b5c483a883a35c00e"
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
