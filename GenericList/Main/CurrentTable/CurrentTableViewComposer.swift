import UIKit

typealias CurrentPageTableRepositoryDecorator = PageTableRepositoryDecorator<CurrentTableResourceModel>
typealias CurrentFilterTableRepositoryDecorator = FilterTableRepositoryDecorator<CurrentTableResourceModel>

enum CurrentTableViewComposer {
    static func compose(provider: Provider) -> UIViewController {
        let currentAvaliationAvailability = AvaliationAvaliablity(
            featureToggle: provider.featureToggle
        )
        let currentTableResourceMapper = CurrentTableResourceMapper()
        let currentTableViewDataMapping = CurrentTableViewDataMapping(
            avaliationAvailablity: currentAvaliationAvailability
        )
        let currentTableRepository = CurrentTableRepository(
            endpoint: .current,
            networkClient: provider.networkClient,
            tableResourceMapper: currentTableResourceMapper
        )
        let currentFilterTableClientDecorator = CurrentFilterTableRepositoryDecorator(currentTableRepository)
        let currentPageTableClientDecorator = CurrentPageTableRepositoryDecorator(currentFilterTableClientDecorator)
        return TableComposer.compose(
            tableRepository: currentPageTableClientDecorator,
            tableViewDataMapper: currentTableViewDataMapping
        )
    }
}
