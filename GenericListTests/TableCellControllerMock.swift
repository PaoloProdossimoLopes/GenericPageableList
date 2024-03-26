import UIKit

@testable import GenericList

final class TableCellControllerMock: TableCellController {
    
    struct Click {
        let tableView: UITableView
        let indexPath: IndexPath
    }
    
    struct Create {
        let tableView: UITableView
        let indexPath: IndexPath
    }
    
    var createStub = UITableViewCell()
    private(set) var clicks = [Click]()
    private(set) var creates = [Create]()
    
    func create(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        creates.append(Create(tableView: tableView, indexPath: indexPath))
        return createStub
    }
    
    func click(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clicks.append(Click(tableView: tableView, indexPath: indexPath))
    }
}

