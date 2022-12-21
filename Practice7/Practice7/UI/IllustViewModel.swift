import Firebase

@MainActor
final class IllustViewModel {
    @Published var illusts: [Illust] = []
    @Published var next: DocumentSnapshot?
    @Published var hasNext: Bool = false
    @Published var isRequesting: Bool = false

    private let repository: IllustRepository

    init(repository: IllustRepository) {
        self.repository = repository
    }

    func fetchIllusts() async {
        isRequesting = true
        do {
            (illusts, next) = try await repository.fetchIllusts()
            hasNext = !illusts.isEmpty
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
        guard let query = next else {
            return
        }
        isRequesting = true
        do {
            let (illusts, next) = try await repository.fetchNextIllusts(query)
            self.illusts += illusts
            self.next = next
            self.hasNext = !illusts.isEmpty
        } catch {
            print(error)
        }
        isRequesting = false
    }
}
