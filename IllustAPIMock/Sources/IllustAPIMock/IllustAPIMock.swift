import CoreData
import Foundation

public class IllustAPIMock {
    var networkMonitor: NetworkMonitor = NetworkMonitorImpl()

    private static let databaseName = "Illusts"
    private static let entityName = "IllustEntity"

    private let container: NSPersistentContainer

    public init() {
        let modelURL = Bundle.module.url(forResource: Self.databaseName, withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        container = NSPersistentContainer(name: Self.databaseName, managedObjectModel: model)
        container.loadPersistentStores { _, _ in }

        setup()

        networkMonitor.start()
    }

    public func getRanking(offset: Int = 0) async throws -> [Illust] {
        // チュートリアルでネットワークエラーを再現できるように
        // 端末がネットワークに繋がってなければエラーを吐くようにする
        guard networkMonitor.isConnected() else {
            throw IllustError.networkError
        }

        let context = container.viewContext
        let request = NSFetchRequest<IllustEntity>(entityName: Self.entityName)
        request.fetchLimit = 4
        request.fetchOffset = offset
        request.sortDescriptors = [NSSortDescriptor(key: "favoritedCount", ascending: false)]
        let result = try context.fetch(request)

        // 実際のネットワークリクエストをしているような体感ができるように1秒待つ
        _ = try await Task.sleep(nanoseconds: 1 * 1_000_000_000)

        return result.map(Illust.init)
    }

    public func getRecommended(offset: Int = 0) async throws -> [Illust] {
        // チュートリアルでネットワークエラーを再現できるように
        // 端末がネットワークに繋がってなければエラーを吐くようにする
        guard networkMonitor.isConnected() else {
            throw IllustError.networkError
        }

        let context = container.viewContext
        let request = NSFetchRequest<IllustEntity>(entityName: Self.entityName)
        request.fetchLimit = 4
        request.fetchOffset = offset
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        let result = try context.fetch(request)

        // 実際のネットワークリクエストをしているような体感ができるように1秒待つ
        _ = try await Task.sleep(nanoseconds: 1 * 1_000_000_000)

        return result.map(Illust.init)
    }

    public func postIsFavorited(illustID: UUID, isFavorited: Bool) async throws -> Illust {
        // チュートリアルでネットワークエラーを再現できるように
        // 端末がネットワークに繋がってなければエラーを吐くようにする
        guard networkMonitor.isConnected() else {
            throw IllustError.networkError
        }

        let context = container.viewContext
        let request = NSFetchRequest<IllustEntity>(entityName: Self.entityName)
        request.predicate = NSPredicate(format: "id = %@", illustID as NSUUID)
        let result = try context.fetch(request)
        guard !result.isEmpty else {
            throw IllustError.notFound
        }

        result[0].isFavorited = isFavorited
        try context.save()

        // 実際のネットワークリクエストをしているような体感ができるように1秒待つ
        _ = try await Task.sleep(nanoseconds: 1 * 1_000_000_000)

        return Illust(entity: result[0])
    }

    public func reset() throws {
        let context = container.viewContext
        let request = NSFetchRequest<IllustEntity>(entityName: Self.entityName)
        let result = try container.viewContext.fetch(request)
        result.forEach { context.delete($0) }
        try context.save()

        setup()
    }

    private func setup() {
        let imageURLs: [String] = [
            "https://firebasestorage.googleapis.com/v0/b/training-ios-2022.appspot.com/o/local%2F01.png?alt=media&token=27a00e90-6651-407b-8b2a-426505091b83",
            "https://firebasestorage.googleapis.com/v0/b/training-ios-2022.appspot.com/o/local%2F02.png?alt=media&token=f601b590-a4e6-46e9-bdc1-c0870cf655b5",
            "https://firebasestorage.googleapis.com/v0/b/training-ios-2022.appspot.com/o/local%2F03.png?alt=media&token=4c13b6ce-92ca-42b6-94d2-19e8cbfb272f",
            "https://firebasestorage.googleapis.com/v0/b/training-ios-2022.appspot.com/o/local%2F04.png?alt=media&token=3f853447-27d5-425b-9b08-31f96d05ccda",
            "https://firebasestorage.googleapis.com/v0/b/training-ios-2022.appspot.com/o/local%2F05.png?alt=media&token=2b9cb02c-7a9c-4df2-8d14-a8b35966a7e4",
            "https://firebasestorage.googleapis.com/v0/b/training-ios-2022.appspot.com/o/local%2F06.png?alt=media&token=4258b079-ec9f-48e7-b276-1535c038cf60",
            "https://firebasestorage.googleapis.com/v0/b/training-ios-2022.appspot.com/o/local%2F07.png?alt=media&token=0438fc2e-f3a2-4d9e-bc05-ac0fd86ed964",
            "https://firebasestorage.googleapis.com/v0/b/training-ios-2022.appspot.com/o/local%2F08.png?alt=media&token=85a1115a-5251-4ca6-b95a-304aab9d17a6",
            "https://firebasestorage.googleapis.com/v0/b/training-ios-2022.appspot.com/o/local%2F09.png?alt=media&token=d631ec3e-43d3-4e2f-8ae1-66eb63b194b2"
        ]

        let context = container.viewContext
        let request = NSFetchRequest<IllustEntity>(entityName: Self.entityName)
        do {
            let result = try context.fetch(request)
            guard result.isEmpty else {
                return
            }

            for urlString in imageURLs {
                let illust = IllustEntity(context: context)
                illust.id = UUID()
                illust.imageURL = URL(string: urlString)
                illust.isFavorited = false
                illust.favoritedCount = 0
                illust.createdAt = Date()
            }

            try context.save()
        } catch {
            print(error)
        }
    }
}
