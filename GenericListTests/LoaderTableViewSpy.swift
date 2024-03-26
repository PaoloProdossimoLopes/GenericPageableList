@testable import GenericList

final class LoaderTableViewSpy: LoaderTableView {
    
    private(set) var displays = [LoadingViewData]()
    
    func display(_ viewData: LoadingViewData) {
        displays.append(viewData)
    }
}
