import UIKit
import AVFoundation

open class LivePhotoViewController: UIViewController {
    
    private var viewModel = LivePhotoViewModel()
    private lazy var captureSessionController = CaptureSessionController()
    public weak var liveCameraDelegate: LivePhotoViewControllerDelegate?
    
    lazy var previewLayer: VideoPreviewView = {
        let previewLayer = VideoPreviewView()
        previewLayer.translatesAutoresizingMaskIntoConstraints = false
        return previewLayer
    }()
    
    lazy var bottomBar: BottomBar = {
        let bottomBar = BottomBar()
        bottomBar.delegate = self
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        return bottomBar
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.checkPermissions()
        DispatchQueue.main.async {
            self.previewLayer.videoPreviewLayer.session = self.captureSessionController.getCaptureSession()
        }
        addDoubleTapRecogniser()
        captureSessionController.delegate = self
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        view.sendSubviewToBack(self.previewLayer)
    }
    
    func setupView() {
        view.addSubview(previewLayer)
        view.addSubview(bottomBar)
        
        NSLayoutConstraint.activate([
            
            bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bottomBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    func addDoubleTapRecogniser() {
        previewLayer.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        previewLayer.addGestureRecognizer(tap)
    }
    
    @objc func doubleTapped() {
        captureSessionController.swapCamera()
    }
}

extension LivePhotoViewController: CaptureSessionControllerDelegate {
    
    func didTakePhoto(image: UIImage) {
        DispatchQueue.main.async {
            self.liveCameraDelegate?.livePhotoCamera(self, didTake: image)
        }
    }
}

extension LivePhotoViewController: BottomBarDelegate {
    
    public func flashButtonTapped() {
        captureSessionController.toggleFlash()
    }
    
    public func photoButtonTapped() {
        captureSessionController.takePhoto()
    }
    
    public func swapCameraButtonTapped() {
        captureSessionController.swapCamera()
    }
}
