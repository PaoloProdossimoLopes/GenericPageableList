@testable import GenericList

final class RetryTableViewSpy: RetryTableView {

    private(set) var displays = [ReloadViewData]()
    
    func display(_ viewData: ReloadViewData) {
        displays.append(viewData)
    }
}

