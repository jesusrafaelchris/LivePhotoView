import UIKit

protocol SwapCameraButtonDelegate: AnyObject {
    func swapCameraButtonTapped()
}

class SwapCameraButton: UIButton {
    
    weak var delegate: SwapCameraButtonDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.addTarget(self, action: #selector(swapCameraButtonTapped), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        if #available(iOS 13.0, *) {
            setsizedImage(symbol: "arrow.triangle.2.circlepath", size: 20, colour: .white)
        } else {
            print("ohno")
        }
    }
    
    @objc func swapCameraButtonTapped() {
        delegate?.swapCameraButtonTapped()
    }
}
