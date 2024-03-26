@testable import GenericList

final class ContentTableViewSpy: ContentTableView {
    
    private(set) var appendViewDatas = [TableViewData]()
    private(set) var updateViewDatas = [TableViewData]()
    
    func display(append viewData: TableViewData) {
        appendViewDatas.append(viewData)
    }
    
    func display(update viewData: TableViewData) {
        updateViewDatas.append(viewData)
    }
}
