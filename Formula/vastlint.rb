class Vastlint < Formula
  desc "VAST XML validator — checks ad tags against IAB VAST 2.0 through 4.3"
  homepage "https://vastlint.org"
  license "Apache-2.0"
  version "0.4.18"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.18/vastlint-macos-aarch64.tar.gz"
      sha256 "f774a436510546688931727c683b8cfe65c61b4cf09c52ed8e34c91b3f9ba6bf"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.18/vastlint-macos-x86_64.tar.gz"
      sha256 "ca192c5d62046cc8cae6fa4823311d00a1e23f183544af65cb677d65879c3bd5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.18/vastlint-linux-aarch64.tar.gz"
      sha256 "a9d8a2d06c34435095225e5acb220a7f061a9a07895d3d134f0543e42e92be66"
    else
      url "https://github.com/aleksUIX/vastlint/releases/download/v0.4.18/vastlint-linux-x86_64.tar.gz"
      sha256 "3a446352d64512673886983dae18aa6ad39935859530fe42d7ee0e5ff24cad6b"
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
