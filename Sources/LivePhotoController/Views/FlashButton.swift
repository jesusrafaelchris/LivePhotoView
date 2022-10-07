import UIKit

protocol FlashButtonDelegate: AnyObject {
    func flashButtonTapped()
}

class FlashButton: UIButton {
    
    weak var delegate: FlashButtonDelegate?
    var isFlashEnabled: Bool = false
    
    required init() {
        super.init(frame: .zero)
        setupView()
        self.addTarget(self, action: #selector(flashButtonTapped), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        if #available(iOS 13.0, *) {
            setsizedImage(symbol: "bolt.slash.fill", size: 20, colour: .white)
        } else {
            print("ohno")
        }
    }
    
    @objc func flashButtonTapped() {
        delegate?.flashButtonTapped()
        isFlashEnabled = !isFlashEnabled
        
        if #available(iOS 13.0, *) {
            isFlashEnabled ? setsizedImage(symbol: "bolt.fill", size: 20, colour: .white) : setsizedImage(symbol: "bolt.slash.fill", size: 20, colour: .white)
        } else {
            print("ohno")
        }
    }
}
