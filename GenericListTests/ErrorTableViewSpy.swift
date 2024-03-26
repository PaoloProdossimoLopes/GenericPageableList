@testable import GenericList

final class ErrorTableViewSpy: ErrorTableView {
    
    private(set) var displays = [ErrorViewData]()
    
    func display(_ viewData: ErrorViewData) {
        displays.append(viewData)
    }
}
