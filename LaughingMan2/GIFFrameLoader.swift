
import AppKit
import ImageIO

class GIFFrameLoader {
    var frames: [NSImage] = []
    var currentFrameIndex = 0

    init?(gifName: String) {
        guard let url = Bundle.main.url(forResource: gifName, withExtension: "gif"),
              let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            print("❌ Could not load GIF from bundle")
            return nil
        }

        let frameCount = CGImageSourceGetCount(imageSource)
        guard frameCount > 0 else {
            print("❌ GIF has no frames")
            return nil
        }

        for i in 0..<frameCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) {
                let nsImage = NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
                frames.append(nsImage)
            }
        }

        print("✅ Loaded \(frames.count) frames from GIF")
    }

    func nextFrame() -> NSImage? {
        guard !frames.isEmpty else { return nil }
        let frame = frames[currentFrameIndex]
        currentFrameIndex = (currentFrameIndex + 1) % frames.count
        return frame
    }
}
