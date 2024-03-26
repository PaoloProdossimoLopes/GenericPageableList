import UIKit

protocol TableCellController {
    func create(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func click(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func height(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
}

extension TableCellController {
    func height(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
