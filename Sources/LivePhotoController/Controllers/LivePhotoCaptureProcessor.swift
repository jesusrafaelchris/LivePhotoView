import UIKit
import AVFoundation

protocol LivePhotoCaptureProcessorDelegate: NSObject {
    func didReturnImage(image: UIImage)
}

class LivePhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    
    weak var delegate: LivePhotoCaptureProcessorDelegate?
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        print("processing photo")
        guard error != nil else {
            print("Error capturing Live Photo still: \(error!)");
            return
        }
        guard let photoData = photo.fileDataRepresentation() else {
            return
        }
        if let mainImage = UIImage(data: photoData) {
            delegate?.didReturnImage(image: mainImage)
        }
    }
}
