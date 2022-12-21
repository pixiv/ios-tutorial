import UIKit

struct IllustSection: Section {
    let parentWidth: CGFloat

    var numberOfItems: Int {
        return 8
    }

    func layoutSection() -> NSCollectionLayoutSection {
        let columns: CGFloat = 2

        let spacing: CGFloat = 8
        let size: CGFloat = (parentWidth - (8 * (columns - 1))) / columns
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(size), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(size))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        return section
    }

    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IllustCell", for: indexPath) as? IllustCell else {
            fatalError()
        }
        return cell
    }
}
