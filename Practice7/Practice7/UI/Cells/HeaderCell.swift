import Nuke
import UIKit

class HeaderCell: UICollectionReusableView {
    @IBOutlet private weak var label: UILabel!

    func bind(_ title: String) {
        label.text = title
    }
}
