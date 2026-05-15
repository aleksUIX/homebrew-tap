class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.4.16"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.16/vastlint-macos-aarch64.tar.gz"
      sha256 "d22bb63ba250b9b6babcdc6ee50b7357c5086fb70eacb7bfab0795c21fdf41fd"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.16/vastlint-macos-x86_64.tar.gz"
      sha256 "59d14031db76a50f8048c8bdff22e51b8e5dfc0ea3b0d4c2b496c523214544fb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.16/vastlint-linux-aarch64.tar.gz"
      sha256 "ff1b01df64e4f21ca425e096a671d72b79bf620ff9e80f77cf8edffb2d2acfb3"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.16/vastlint-linux-x86_64.tar.gz"
      sha256 "166c8b372a0b8d80768b00506ac21a67fbf32d851c619646ed451f574aa6ebe9"
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
