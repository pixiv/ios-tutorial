import Network

public protocol NetworkMonitor {
    func start()
    func isConnected() -> Bool
}

public class NetworkMonitorImpl: NetworkMonitor {
    private let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
    private let queue = DispatchQueue.global(qos: .background)

    public func start() {
        monitor.start(queue: queue)
    }

    public func isConnected() -> Bool {
        return monitor.currentPath.status == .satisfied
    }
}
