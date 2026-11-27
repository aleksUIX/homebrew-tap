class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.4"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.17.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint-tools/releases/download/cli-v0.17.0/vastlint-macos-aarch64.tar.gz"
      sha256 "15bcebaa8af7a199d5e17bd2e366cd10374002a126e91d39dee0041a8ff80ecb"
    else
      url "https://github.com/aleksUIX/vastlint-tools/releases/download/cli-v0.17.0/vastlint-macos-x86_64.tar.gz"
      sha256 "49edab16c6f1f35a675a026b71a4baeb5ee7b6bdfc9a214c739e4a6175f070fa"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint-tools/releases/download/cli-v0.17.0/vastlint-linux-aarch64.tar.gz"
      sha256 "2b113ec4ffcf82a76461239e9cc7e6583a3a41012b7a161bf78554d419e8bc98"
    else
      url "https://github.com/aleksUIX/vastlint-tools/releases/download/cli-v0.17.0/vastlint-linux-x86_64.tar.gz"
      sha256 "604f0922536b1878e175164729edcbf28dbfe9c7cb26a2a3a2859bc2bbe4ca6e"
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
