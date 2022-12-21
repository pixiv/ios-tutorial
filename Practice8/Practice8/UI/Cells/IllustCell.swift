import Nuke
import UIKit

class IllustCell: UICollectionViewCell {
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFill
        }
    }

    private var illust: Illust?
    private var heartTapped: ((Illust) -> Void)?

    func bind(_ illust: Illust, heartTapped: @escaping (Illust) -> Void) {
        if let url = URL(string: illust.imageUrl) {
            Nuke.loadImage(with: url, into: imageView)
        }
        button.configuration?.image = UIImage(systemName: illust.isFavorited ? "heart.fill" : "heart")
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
