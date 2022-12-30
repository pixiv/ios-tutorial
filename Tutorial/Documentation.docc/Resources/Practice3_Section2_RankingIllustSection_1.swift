import UIKit

struct RankingIllustSection: Section {
    var numberOfItems: Int {
        return 4
    }

    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: ..., heightDimension: ...)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: ..., heightDimension: ...)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(32)),
            elementKind: "RankingHeader",
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }

    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingIllustCell", for: indexPath) as? RankingIllustCell else {
            fatalError()
        }
        return cell
    }
}
