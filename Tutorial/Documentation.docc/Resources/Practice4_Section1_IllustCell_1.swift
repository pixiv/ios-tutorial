import IllustAPIMock
import UIKit

class IllustCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .red
    }

    func bind(_ illust: Illust) {
    }
}
