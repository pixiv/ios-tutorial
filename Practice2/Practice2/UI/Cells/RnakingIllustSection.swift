import UIKit

struct RankingIllustSection: Section {
    let parentWidth: CGFloat

    var numberOfItems: Int {
        return 4
    }

    func layoutSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 8
        let size: CGFloat = 256
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(size), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(size), heightDimension: .absolute(size))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 8, bottom: 8, trailing: 0)
        section.interGroupSpacing = spacing
        return section
    }

    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingIllustCell", for: indexPath) as? RankingIllustCell else {
            fatalError()
        }
        return cell
    }
}
