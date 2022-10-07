import UIKit

public protocol LivePhotoViewControllerDelegate: AnyObject {
    func livePhotoCamera(_ livePhotoCamera: LivePhotoViewController, didTake photo: UIImage)
}
