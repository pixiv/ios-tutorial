import Firebase

@MainActor
final class IllustViewModel {
    @Published var illusts: [Illust] = []

    private let repository: IllustRepository

    init(repository: IllustRepository) {
        self.repository = repository
    }

    func fetchIllusts() async {
        do {
            (illusts, _) = try await repository.fetchIllusts()
        } catch {
            print(error)
        }
    }
}
