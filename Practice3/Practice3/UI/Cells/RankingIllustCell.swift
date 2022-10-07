import UIKit

class RankingIllustCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .green
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
