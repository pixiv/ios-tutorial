import FirebaseAuth
import FirebaseFirestoreSwift
import Foundation

struct Illust: Codable {
    @DocumentID var id: String?
    let imageUrl: String
    var favoriteCount: Int
    var favoritedUsers: [String]?
    let createdAt: Date

    var isFavorited: Bool {
        get {
            guard let uid = Auth.auth().currentUser?.uid else {
                return false
            }
            guard let favoritedUsers = favoritedUsers else {
                return false
            }
            return favoritedUsers.contains(uid)
        }
    }
}
