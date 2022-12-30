import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            registerCells()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = {
            let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
                switch sectionIndex {
                case 0: // ランキング
                    let item = ...
                    let group = ...
                    let section = ...
                    return section
                case 1: // おすすめ
                    let item = ...
                    let group = ...
                    let section = ...
                    return section
                }
            }
            return layout
        }()
    }
}

extension MainViewController {
    private func registerCells() {
        collectionView.register(UINib(nibName: "HeaderCell", bundle: nil), forSupplementaryViewOfKind: "RecommendedHeader", withReuseIdentifier: "HeaderCell")
        collectionView.register(UINib(nibName: "HeaderCell", bundle: nil), forSupplementaryViewOfKind: "RankingHeader", withReuseIdentifier: "HeaderCell")
        collectionView.register(UINib(nibName: "IllustCell", bundle: nil),  forCellWithReuseIdentifier: "IllustCell")
        collectionView.register(UINib(nibName: "RankingIllustCell", bundle: nil),  forCellWithReuseIdentifier: "RankingIllustCell")
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingIllustCell", for: indexPath) as? RankingIllustCell else {
                fatalError()
            }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IllustCell", for: indexPath) as? IllustCell else {
                fatalError()
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as? HeaderCell else {
            fatalError()
        }
        switch kind {
        case "RecommendedHeader":
            header.bind("Recommended")
            return header
        case "RankingHeader":
            header.bind("Ranking")
            return header
        default:
            fatalError()
         }
    }
}
