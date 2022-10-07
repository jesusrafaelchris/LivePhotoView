import UIKit

public protocol BottomBarDelegate: AnyObject {
    func flashButtonTapped()
    func photoButtonTapped()
    func swapCameraButtonTapped()
}

class BottomBar: UIView {
    
    public weak var delegate: BottomBarDelegate?
    private var insideButtonSize: CGFloat = 48
    private var outsideButtonSize: CGFloat = 60
    
    lazy var flashButton: FlashButton = {
        let flashButton = FlashButton()
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        flashButton.delegate = self
        return flashButton
    }()
    
    lazy var takePhotoButton: PhotoButton = {
        let takePhotoButton = PhotoButton()
        takePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        takePhotoButton.layer.cornerRadius = insideButtonSize / 2
        takePhotoButton.layer.masksToBounds = true
        takePhotoButton.delegate = self
        return takePhotoButton
    }()
    
    lazy var photoButtonBorderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = outsideButtonSize / 2
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var swapCameraButton: SwapCameraButton = {
        let swapCameraButton = SwapCameraButton()
        swapCameraButton.translatesAutoresizingMaskIntoConstraints = false
        swapCameraButton.delegate = self
        return swapCameraButton
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 45, bottom: 16, trailing: 45)
        stackView.alignment = .center
        stackView.addArrangedSubview(flashButton)
        stackView.addArrangedSubview(photoButtonBorderView)
        stackView.addArrangedSubview(swapCameraButton)
        return stackView
    }()
    
    required init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        addSubview(stackView)
        backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.75)
        layer.cornerRadius = 28
        layer.masksToBounds = true
        
        photoButtonBorderView.addSubview(takePhotoButton)
        
        NSLayoutConstraint.activate([
    
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            takePhotoButton.heightAnchor.constraint(equalToConstant: insideButtonSize),
            takePhotoButton.widthAnchor.constraint(equalTo: takePhotoButton.heightAnchor),
            
            photoButtonBorderView.heightAnchor.constraint(equalToConstant: outsideButtonSize),
            photoButtonBorderView.widthAnchor.constraint(equalTo: photoButtonBorderView.heightAnchor),
            
            photoButtonBorderView.centerXAnchor.constraint(equalTo: takePhotoButton.centerXAnchor),
            photoButtonBorderView.centerYAnchor.constraint(equalTo: takePhotoButton.centerYAnchor),
            
        ])
    }
}

extension BottomBar: FlashButtonDelegate, PhotoButtonDelegate, SwapCameraButtonDelegate {
    
    func flashButtonTapped() {
        delegate?.flashButtonTapped()
    }
    
    func photoButtonTapped() {
        delegate?.photoButtonTapped()
    }
    
    func swapCameraButtonTapped() {
        delegate?.swapCameraButtonTapped()
    }
}
