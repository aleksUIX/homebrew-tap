class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.4.22"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.22/vastlint-macos-aarch64.tar.gz"
      sha256 "5ad2f1fd646a19024787704972eaa58c7f6e0ca26b4c8f2f4d7b3332cb27fe7d"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.22/vastlint-macos-x86_64.tar.gz"
      sha256 "929f5a3df6975f3ce06d8fb92d69f2523fbc6449ff5f512b413fcfacd7807cff"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.22/vastlint-linux-aarch64.tar.gz"
      sha256 "d01e51fe25d94fcfc6e236c7990ef0668667d17eb9a4ece56a6f74b5184e47fc"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.22/vastlint-linux-x86_64.tar.gz"
      sha256 "c1ec7851b435bedaa152094487fcad89862b069bb2b3a7215a5deb503252b692"
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
