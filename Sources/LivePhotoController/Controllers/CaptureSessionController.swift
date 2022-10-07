import AVFoundation
import UIKit

protocol CaptureSessionControllerDelegate: NSObject {
    func didTakePhoto(image: UIImage)
}

class CaptureSessionController: NSObject {
    
    private lazy var captureSession = AVCaptureSession()
    private var output = AVCapturePhotoOutput()
    private var videoDevice: AVCaptureDevice?
    private var defaultCamera = CameraMode.back
    private(set) var currentCamera = CameraMode.back
    public var flashMode: AVCaptureDevice.FlashMode = .off
    weak var delegate: CaptureSessionControllerDelegate?
    
    override init() {
        super.init()
        currentCamera = defaultCamera
        initialiseCaptureSession()
        startSession()
    }
    
    func getCaptureSession() -> AVCaptureSession {
        return captureSession
    }
    
    func swapCamera() {
        switch currentCamera {
        case .front:
            currentCamera = .back
        case .back:
            currentCamera = .front
        }
        captureSession.stopRunning()
        for input in captureSession.inputs {
            captureSession.removeInput(input)
        }
        
        for output in captureSession.outputs {
            captureSession.removeOutput(output)
        }
        
        initialiseCaptureSession()
        startSession()
    }
    
    func toggleFlash() {
        guard self.currentCamera == .back else { return }
        flashMode = (flashMode == .on) ? .off : .on
    }
    
    func takeLivePhoto() {
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        photoSettings.livePhotoMovieFileURL = nil //URL.tempFile(withFileExtension: "mov")
        photoSettings.flashMode = flashMode
        
        let captureProcessor = LivePhotoCaptureProcessor()
        captureProcessor.delegate = self
        output.capturePhoto(with: photoSettings, delegate: captureProcessor)
    }
    
    func takePhoto() {
        print("taking photo")
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = flashMode
//        let captureProcessor = LivePhotoCaptureProcessor()
//        captureProcessor.delegate = self
        output.capturePhoto(with: photoSettings, delegate: self)
    }
}

extension CaptureSessionController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        print("processing photo")
        guard let photoData = photo.fileDataRepresentation() else {
            return
        }
        if let mainImage = UIImage(data: photoData) {
            delegate?.didTakePhoto(image: mainImage)
        }
    }
}

extension CaptureSessionController: LivePhotoCaptureProcessorDelegate {
    func didReturnImage(image: UIImage) {
        print("returning photo")
        delegate?.didTakePhoto(image: image)
    }
}

private extension CaptureSessionController {
    
    func getVideoCaptureDevice(position: AVCaptureDevice.Position)  -> AVCaptureDevice? {
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
    }
    
    func getCaptureDeviceInput(captureDevice: AVCaptureDevice) -> AVCaptureDeviceInput? {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            return captureDeviceInput
        }
        catch { print(error) }
        return nil
    }
    
    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async { [ weak self ] in
            self?.captureSession.startRunning()
        }
    }
    
    func setupVideoInputs() {
        switch currentCamera {
        case .front:
            videoDevice = getVideoCaptureDevice(position: .front)
        case .back:
            videoDevice = getVideoCaptureDevice(position: .back)
        }
        guard let videoDevice = self.videoDevice else { return }
        guard let videoDeviceInput = getCaptureDeviceInput(captureDevice: videoDevice) else { return }
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
    }
    
    //troublemaker
    func setupPhotoOutput() {
        let photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else { return }
        //troublemaker
        //captureSession.sessionPreset = .photo
        //good
        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
        captureSession.addOutput(photoOutput)
        self.output = photoOutput
    }
    
    func initialiseCaptureSession() {
        print("initialising")
        setupVideoInputs()
        setupAudioInputs()
        setupPhotoOutput()
        configureDevice()
    }
    
    func setupAudioInputs() {
        do {
            guard let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio) else { return }
            let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
            guard captureSession.canAddInput(audioDeviceInput) else { return }
            captureSession.addInput(audioDeviceInput)
        } catch { print(error) }
    }
    
    func configureDevice() {
        if let device = videoDevice {
            do {
                try device.lockForConfiguration()
                if device.isFocusModeSupported(.continuousAutoFocus) {
                    device.focusMode = .continuousAutoFocus
                    if device.isSmoothAutoFocusSupported {
                        device.isSmoothAutoFocusEnabled = true
                    }
                }

                if device.isExposureModeSupported(.continuousAutoExposure) {
                    device.exposureMode = .continuousAutoExposure
                }

                if device.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
                    device.whiteBalanceMode = .continuousAutoWhiteBalance
                }

                if device.isLowLightBoostSupported {
                    device.automaticallyEnablesLowLightBoostWhenAvailable = true
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Error locking configuration")
            }
        }
    }
}
