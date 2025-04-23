
import AVFoundation
import Vision
import AppKit

class CameraManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let sequenceHandler = VNSequenceRequestHandler()
    private let queue = DispatchQueue(label: "videoQueue")
    @Published var faceBoundingBox: CGRect?
    @Published var currentFrame: NSImage?
    var frameLoader = GIFFrameLoader(gifName: "laughingman")

    override init() {
        super.init()
        configureSession()
    }

    private func configureSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            print("❌ Failed to access camera")
            return
        }

        session.beginConfiguration()
        if session.canAddInput(input) {
            session.addInput(input)
        }

        videoOutput.setSampleBufferDelegate(self, queue: queue)
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        session.commitConfiguration()
    }

    func startSession() {
        session.startRunning()
    }

    func stopSession() {
        session.stopRunning()
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        try? sequenceHandler.perform([VNDetectFaceRectanglesRequest(completionHandler: { [weak self] request, _ in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let result = (request.results as? [VNFaceObservation])?.first {
                    // 🔄 Pass raw normalized coordinates (0–1)
                    self.faceBoundingBox = result.boundingBox
                } else {
                    self.faceBoundingBox = nil
                }
            }
        })], on: buffer)

        let ciImage = CIImage(cvPixelBuffer: buffer)
        let context = CIContext()
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            let nsImage = NSImage(cgImage: cgImage, size: .zero)
            DispatchQueue.main.async {
                self.currentFrame = nsImage
            }
        }
    }

    func nextGIFFrame() -> NSImage? {
        return frameLoader?.nextFrame()
    }
}
