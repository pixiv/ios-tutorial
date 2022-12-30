import Combine
import IllustAPIMock

final class IllustViewModel {
    @Published var rankingIllusts: [Illust] = []
    @Published var recommendedIllusts: [Illust] = []

    private let api: IllustAPIMock

    init(api: IllustAPIMock) {
        self.api = api
    }

    func fetchIllusts() async {
        do {
            rankingIllusts = try await api.getRanking()
            recommendedIllusts = try await api.getRecommended()
        } catch {
            print(error)
        }
    }
}
