import Nuke
import UIKit

class HeaderCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!

    func bind(_ title: String) {
        label.text = title
    }
}
