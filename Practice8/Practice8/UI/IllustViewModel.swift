import Combine
import IllustAPIMock

@MainActor
final class IllustViewModel {
    @Published var rankingIllusts: [Illust] = []
    @Published var recommendedIllusts: [Illust] = []
    @Published var offset: Int = 0
    @Published var hasNext: Bool = false
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
            hasNext = !recommendedIllusts.isEmpty
        } catch {
            print(error)
        }
        isRequesting = false
    }

    func fetchNextIllusts() async {
        guard !isRequesting else {
            return
        }
        guard hasNext else {
            return
        }
        isRequesting = true
        do {
            let illusts = try await api.getRecommended(offset: offset)
            self.recommendedIllusts += illusts
            self.offset += illusts.count
            self.hasNext = !illusts.isEmpty
        } catch {
            print(error)
        }
        isRequesting = false
    }

    func favorite(illust: Illust) async {
        recommendedIllusts = recommendedIllusts.map {
            if $0.id == illust.id {
                var newIllust = illust
                newIllust.isFavorited = true
                return newIllust
            }
            return $0
        }

        do {
            _ = try await api.postIsFavorited(illustID: illust.id, isFavorited: true)
        } catch {
            // エラーが起きたら元に戻す
            recommendedIllusts = recommendedIllusts.map {
                if $0.id == illust.id {
                    var newIllust = illust
                    newIllust.isFavorited = false
                    return newIllust
                }
                return $0
            }
        }
    }
}
