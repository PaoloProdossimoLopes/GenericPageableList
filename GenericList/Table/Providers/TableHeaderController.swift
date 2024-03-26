import UIKit

protocol TableHeaderController: Identifier {
    func create(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    func height(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
}

extension TableHeaderController {
    func height(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
}
