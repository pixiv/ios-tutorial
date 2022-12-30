import Combine
import IllustAPIMock

final class IllustViewModel {
    @Published var rankingIllusts: [Illust] = []
    @Published var recommendedIllusts: [Illust] = []
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
        } catch {
            print(error)
        }
        isRequesting = false
    }

    func fetchNextIllusts() async {
    }
}
