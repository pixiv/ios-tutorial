import IllustAPIMock
import Nuke
import UIKit

class RankingIllustCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 8
            imageView.layer.masksToBounds = true
        }
    }

    func bind(_ illust: Illust) {
        Nuke.loadImage(with: illust.imageURL, into: imageView)
    }
}
