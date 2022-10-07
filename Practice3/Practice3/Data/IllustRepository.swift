import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

protocol IllustRepository {
    func fetchIllusts() async throws -> ([Illust], DocumentSnapshot?)
    func fetchNextIllusts(_ query: DocumentSnapshot) async throws -> ([Illust], DocumentSnapshot?)
    func favorite(illust: Illust) async throws -> Illust?
}

class IllustRepositoryImpl: IllustRepository {
    struct Const {
        static let maxCount: Int = 4
    }

    func fetchIllusts() async throws -> ([Illust], DocumentSnapshot?) {
        let snapshot = try await Firestore.firestore().collection("illusts")
            .order(by: "createdAt", descending: true)
            .limit(to: Const.maxCount)
            .getDocuments()

        let illuts = snapshot.documents.compactMap {
            try? $0.data(as: Illust.self)
        }
        return (illuts, snapshot.documents.last)
    }

    func fetchNextIllusts(_ query: DocumentSnapshot) async throws -> ([Illust], DocumentSnapshot?) {
        let snapshot = try await Firestore.firestore().collection("illusts")
            .order(by: "createdAt", descending: true)
            .limit(to: Const.maxCount)
            .start(afterDocument: query)
            .getDocuments()

        let illuts = snapshot.documents.compactMap {
            try? $0.data(as: Illust.self)
        }
        return (illuts, snapshot.documents.last)
    }

    func favorite(illust: Illust) async throws -> Illust? {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        guard let illustID = illust.id else {
            return nil
        }
        guard !illust.isFavorited else {
            return nil
        }
        let ref = Firestore.firestore()
            .collection("illusts")
            .document(illustID)
        try await ref.setData([
            "favoriteCount": FieldValue.increment(Int64(1)),
            "favoritedUsers": [
                uid
            ]
        ], merge: true)
        return try await ref.getDocument().data(as: Illust.self)
    }
}
