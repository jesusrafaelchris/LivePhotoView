import Foundation
import AVFoundation

public enum FlashMode {
    case auto
    case on
    case off
    
    var AVFlashMode: AVCaptureDevice.FlashMode {
        switch self {
            case .on:
                return .on
            case .off:
                return .off
            case .auto:
                return .auto
        }
    }
}
