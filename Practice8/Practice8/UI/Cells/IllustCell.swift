import Nuke
import IllustAPIMock
import UIKit

class IllustCell: UICollectionViewCell {
    @IBOutlet private weak var heartButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFill
        }
    }

    private var illust: Illust?
    private var heartTapped: ((Illust) -> Void)?

    func bind(_ illust: Illust, heartTapped: @escaping (Illust) -> Void) {
        Nuke.loadImage(with: illust.imageURL, into: imageView)
        heartButton.configuration?.image = UIImage(systemName: illust.isFavorited ? "heart.fill" : "heart")
        self.illust = illust
        self.heartTapped = heartTapped
    }

    @IBAction private func handleHeartButtonTapped(_ sender: UIButton) {
        guard let illust = illust else {
            return
        }
        heartTapped?(illust)
    }
}
