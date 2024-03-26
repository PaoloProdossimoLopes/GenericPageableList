import UIKit

enum UserTableComposer {
    static func compose(provider: Provider) -> UIViewController {
        let userModelMapper = UserModelMapper()
        let userTableViewDataMapper = UserTableViewDataMapper()
        let userTableRepository = UserTableRepository(
            endpoint: .cashFlow,
            networkClient: provider.networkClient,
            tableResourceMapper: userModelMapper)
        return TableComposer.compose(
            tableRepository: userTableRepository,
            tableViewDataMapper: userTableViewDataMapper
        )
    }
}
