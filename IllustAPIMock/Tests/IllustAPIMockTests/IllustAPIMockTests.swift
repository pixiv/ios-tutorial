import XCTest
@testable import IllustAPIMock

class NetworkMonitorMock: NetworkMonitor {
    var _isConnected: Bool = true

    func start() {
    }

    func isConnected() -> Bool {
        return _isConnected
    }
}

final class IllustAPIMockTests: XCTestCase {
    override func setUp() {
        let api = IllustAPIMock()
        try! api.reset()
    }

    func testGetRanking() async throws {
        let networkMonitor = NetworkMonitorMock()
        networkMonitor._isConnected = true

        let api = IllustAPIMock()
        api.networkMonitor = networkMonitor

        let result = try await api.getRanking()
        XCTAssertGreaterThan(result.count, 0)
    }

    func testGetRankingWithoutNetwork() async throws {
        let networkMonitor = NetworkMonitorMock()
        networkMonitor._isConnected = false

        let api = IllustAPIMock()
        api.networkMonitor = networkMonitor

        await XCTAssertThrowsError(try await api.getRanking())
    }

    func testGetRecommended() async throws {
        let networkMonitor = NetworkMonitorMock()
        networkMonitor._isConnected = true

        let api = IllustAPIMock()
        api.networkMonitor = networkMonitor

        let result = try await api.getRecommended()
        XCTAssertGreaterThan(result.count, 0)
    }

    func testGetRecommendedWithoutNetwork() async throws {
        let networkMonitor = NetworkMonitorMock()
        networkMonitor._isConnected = false

        let api = IllustAPIMock()
        api.networkMonitor = networkMonitor

        await XCTAssertThrowsError(try await api.getRecommended())
    }
}
