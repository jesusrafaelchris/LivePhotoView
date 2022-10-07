import UIKit

public protocol PhotoButtonDelegate: AnyObject {
    func photoButtonTapped()
}

class PhotoButton: UIButton {
    
    public weak var delegate: PhotoButtonDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        backgroundColor = .white
    }
    
    @objc func photoButtonTapped() {
        delegate?.photoButtonTapped()
    }
}
