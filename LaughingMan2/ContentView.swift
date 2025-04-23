
import SwiftUI

struct ContentView: View {
    @StateObject var cameraManager = CameraManager()
    @State private var showOverlay = true

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CameraView(image: cameraManager.currentFrame)

                if showOverlay,
                   let faceBox = cameraManager.faceBoundingBox,
                   let frame = cameraManager.nextGIFFrame() {
                    FaceOverlayRenderer(boundingBox: faceBox, image: frame, geometrySize: geometry.size)
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showOverlay.toggle()
                        }) {
                            Image(systemName: showOverlay ? "eye.slash.fill" : "eye.fill")
                                .font(.title2)
                                .padding(10)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 25)
                        .padding(.trailing, 20)
                    }
                }
            }
            .onAppear {
                cameraManager.startSession()
            }
            .onDisappear {
                cameraManager.stopSession()
            }
        }
    }
}
