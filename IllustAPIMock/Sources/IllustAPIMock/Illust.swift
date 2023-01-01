import Foundation

public struct Illust {
    public let id: UUID
    public let imageURL: URL
    public var isFavorited: Bool
    public var favoritedCount: Int
    public let createdAt: Date

    public init(entity: IllustEntity) {
        id = entity.id!
        imageURL = entity.imageURL!
        isFavorited = entity.isFavorited
        favoritedCount = Int(entity.favoritedCount)
        createdAt = entity.createdAt!
    }
}
