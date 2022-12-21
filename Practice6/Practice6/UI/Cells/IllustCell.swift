import Nuke
import UIKit

class IllustCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFill
        }
    }

    private var illust: Illust?

    func bind(_ illust: Illust) {
        if let url = URL(string: illust.imageUrl) {
            Nuke.loadImage(with: url, into: imageView)
        }
        self.illust = illust
    }
}
