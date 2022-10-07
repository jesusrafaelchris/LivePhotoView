import AVFoundation
import UIKit

protocol LivePhotoViewModelProtocol: AnyObject {
    func checkPermissions()
}

class LivePhotoViewModel: LivePhotoViewModelProtocol {
    
    private var cameraAuthorizationStatus = RequestAuthorizationController.getAuthorizationStatus(for: .video) {
        didSet { checkPermissions() }
    }
    
    private var microphoneAuthorizationStatus = RequestAuthorizationController.getAuthorizationStatus(for: .audio) {
        didSet { checkPermissions() }
    }
    
    func checkPermissions() {
        guard cameraAuthorizationStatus == .granted else {
            requestCameraPermissions()
            return
        }
        
        guard microphoneAuthorizationStatus == .granted else {
            requestMicrophonePermissions()
            return
        }
        
        print("Have all permissions can proceed")
    }
    
    private func requestCameraPermissions() {
        switch cameraAuthorizationStatus {
        case .granted:
            break
        case .notRequested:
            RequestAuthorizationController.requestAuthorization(for: .video) { [ weak self ] status in
                self?.cameraAuthorizationStatus = status
            }
        case .unauthorized:
            print("unauthorised need to take you to settings")
            // have a button that can take you to settings
            //openSettings()
        }
    }
    
    private func requestMicrophonePermissions() {
        switch microphoneAuthorizationStatus {
        case .granted:
            break
        case .notRequested:
            RequestAuthorizationController.requestAuthorization(for: .audio) { [ weak self ] status in
                self?.microphoneAuthorizationStatus = status
            }
        case .unauthorized:
            print("unauthorised need to take you to settings")
            // have a button that can take you to settings
            //openSettings()
        }
    }
    
    private func openSettings() {
        let settingsURLString = UIApplication.openSettingsURLString
        if let settingsURL = URL(string: settingsURLString) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
}
