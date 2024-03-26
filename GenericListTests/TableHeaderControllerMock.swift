import UIKit

@testable import GenericList

final class TableHeaderControllerMock: TableHeaderController {
    struct Create {
        let tableView: UITableView
        let section: Int
    }
    
    let id: String
    
    init(id: String = UUID().uuidString) {
        self.id = id
    }
    
    var createStub: UIView?
    private(set) var creates = [Create]()
    
    func create(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        creates.append(Create(tableView: tableView, section: section))
        return createStub
    }
}
