import Combine
import IllustAPIMock
import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            registerCells()
        }
    }
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!

    private var sections: [Section] = [] {
        didSet {
            Task { @MainActor in
                self.collectionView.collectionViewLayout = {
                    let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
                        return self.sections[sectionIndex].layoutSection()
                    }
                    return layout
                }()
                self.collectionView.reloadData()
            }
        }
    }

    private let viewModel = IllustViewModel(api: IllustAPIMock())
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.$rankingIllusts
            .combineLatest(viewModel.$recommendedIllusts)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rankingIllusts, recommendedIllusts in
                guard let self = self else {
                    return
                }
                self.sections = [
                    RankingIllustSection(illusts: rankingIllusts),
                    IllustSection(illusts: recommendedIllusts, parentWidth: self.view.bounds.width)
                ]
            }
            .store(in: &cancellables)

        viewModel.$isRequesting
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isRequesting in
                self?.loadingView.isHidden = !isRequesting
            }
            .store(in: &cancellables)

        Task {
            await viewModel.fetchIllusts()
        }
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height else {
            return
        }
        Task {
            await viewModel.fetchNextIllusts()
        }
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

extension MainViewController: UICollectionViewDelegate {
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return sections[indexPath.section].configureCell(collectionView: collectionView, indexPath: indexPath)
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
