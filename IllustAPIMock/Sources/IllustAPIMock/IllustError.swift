import Foundation

public enum IllustError: LocalizedError {
    case networkError
    case notFound

    public var errorDescription: String? {
        switch self {
        case .networkError:
            return "ネットワークに繋がっていません"

        case .notFound:
            return "対象のイラストが見つかりません"
        }
    }
}
