import Nuke
import UIKit

class RankingIllustCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 8
            imageView.layer.masksToBounds = true
        }
    }

    func bind(_ illust: Illust) {
        if let url = URL(string: illust.imageUrl) {
            Nuke.loadImage(with: url, into: imageView)
        }
    }
}
