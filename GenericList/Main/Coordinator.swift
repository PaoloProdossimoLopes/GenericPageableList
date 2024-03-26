import UIKit

final class Coordinator {
    
    private let provider: Provider
    private let window: UIWindow
    
    init(provider: Provider, window: UIWindow) {
        self.provider = provider
        self.window = window
    }
    
    func start() {
        let currentTableViewController = CurrentTableViewComposer.compose(provider: provider)
        window.rootViewController = currentTableViewController
        window.makeKeyAndVisible()
    }
}
