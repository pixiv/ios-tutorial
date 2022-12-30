import Combine
import IllustAPIMock

@MainActor
final class IllustViewModel {
    @Published var rankingIllusts: [Illust] = []
    @Published var recommendedIllusts: [Illust] = []
    @Published var offset: Int = 0
    @Published var isRequesting: Bool = false

    private let api: IllustAPIMock

    init(api: IllustAPIMock) {
        self.api = api
    }

    func fetchIllusts() async {
        isRequesting = true
        do {
            rankingIllusts = try await api.getRanking()
            recommendedIllusts = try await api.getRecommended()
            offset = recommendedIllusts.count
        } catch {
            print(error)
        }
        isRequesting = false
    }

    func fetchNextIllusts() async {
        guard !isRequesting else {
            return
        }
        isRequesting = true
        do {
            let illusts = try await api.getRecommended(offset: offset)
            self.recommendedIllusts += illusts
            self.offset = recommendedIllusts.count
        } catch {
            print(error)
        }
        isRequesting = false
    }
}
