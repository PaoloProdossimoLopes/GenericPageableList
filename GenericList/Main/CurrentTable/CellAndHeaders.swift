import UIKit


final class PeriodTableHanderController: TableHeaderController {
    
    let id = String(describing: PeriodTableHanderController.self)
    
    func create(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Period Header"
        return label
    }
}

final class NoneTableHanderController: TableHeaderController {
    
    let id = String(describing: NoneTableHanderController.self)
    
    func create(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    
    func height(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
}

final class DaySectionTableHanderController: TableHeaderController {
    let id = UUID().uuidString
    
    func create(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Day Header"
        return label
    }
}

final class TodaySectionTableHanderController: TableHeaderController {
    
    let id = UUID().uuidString
    
    func create(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Today Header"
        return label
    }
}

final class EventItemTableCellController: TableCellController {
    
    func create(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Event"
        cell.selectionStyle = .none
        return cell
    }
    
    func click(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Event is Selected")
    }
}

final class ErrorTableCellController: TableCellController {
    
    private let retry: Completion
    
    init(retry: @escaping Completion) {
        self.retry = retry
    }
    
    func create(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Error"
        cell.selectionStyle = .none
        return cell
    }
    
    func click(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        retry()
    }
}

final class EmptyTableCellController: TableCellController {
    
    func create(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Empty"
        cell.selectionStyle = .none
        return cell
    }
    
    func click(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

final class AvaliationTableCellController: TableCellController {
    
    func create(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Avaliation"
        cell.selectionStyle = .none
        return cell
    }
    
    func click(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

final class FooterTableCellController: TableCellController {
    
    func create(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Footer"
        cell.selectionStyle = .none
        return cell
    }
    
    func click(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
