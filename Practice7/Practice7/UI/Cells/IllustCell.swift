import IllustAPIMock
import Nuke
import UIKit

class IllustCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFill
        }
    }

    func bind(_ illust: Illust) {
        Nuke.loadImage(with: illust.imageURL, into: imageView)
    }
}
