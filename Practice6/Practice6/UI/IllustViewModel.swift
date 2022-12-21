import Firebase

@MainActor
final class IllustViewModel {
    @Published var illusts: [Illust] = []
    @Published var isRequesting: Bool = false

    private let repository: IllustRepository

    init(repository: IllustRepository) {
        self.repository = repository
    }

    func fetchIllusts() async {
        isRequesting = true
        do {
            (illusts, _) = try await repository.fetchIllusts()
        } catch {
            print(error)
        }
        isRequesting = false
    }
}
