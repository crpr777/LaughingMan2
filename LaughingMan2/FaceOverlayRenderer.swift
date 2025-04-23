
import SwiftUI

struct FaceOverlayRenderer: View {
    let boundingBox: CGRect
    let image: NSImage
    let geometrySize: CGSize

    var body: some View {
        let width = boundingBox.width * geometrySize.width
        let height = boundingBox.height * geometrySize.height
        let x = boundingBox.midX * geometrySize.width
        let y = (1 - boundingBox.midY) * geometrySize.height

        return Image(nsImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
            .position(x: x, y: y)
    }
}
