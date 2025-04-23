
import SwiftUI

struct CameraView: View {
    let image: NSImage?

    var body: some View {
        GeometryReader { geo in
            if let img = image {
                Image(nsImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            } else {
                Color.black
            }
        }
    }
}
