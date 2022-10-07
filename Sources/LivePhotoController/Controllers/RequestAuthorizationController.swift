import Foundation
import AVFoundation

enum PermissionsAuthorizationStatus {
    case granted
    case notRequested
    case unauthorized
}

typealias RequestAuthorizationCompletionHandler = (PermissionsAuthorizationStatus) -> Void

class RequestAuthorizationController {
    
    static func requestAuthorization(for media: AVMediaType, completionHandler: @escaping RequestAuthorizationCompletionHandler) {
        AVCaptureDevice.requestAccess(for: media) { granted in
            DispatchQueue.main.async {
                guard granted else {
                    completionHandler(.unauthorized)
                    return
                }
                completionHandler(.granted)
            }
        }
    }
    
    static func getAuthorizationStatus(for media: AVMediaType) -> PermissionsAuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: media)
        switch status {
        case .authorized:
            return .granted
        case .notDetermined:
            return .notRequested
        default:
            return .unauthorized
        }
    }
}
