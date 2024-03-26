import UIKit

class TableViewController: UITableViewController {
    
    var loadResource: CompletionWith<Bool>?
    
    private var isLoading = false
    private let tableDatabase: TableDataManaging
    
    init(tableDatabase: TableDataManaging) {
        self.tableDatabase = tableDatabase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadResource?(false)
    }
    
    func append(_ newSections: [TableSection]) {
        tableDatabase.appendSections(newSections)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func update(_ newSections: [TableSection]) {
        tableDatabase.updateSections(newSections)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
     
    override func numberOfSections(in tableView: UITableView) -> Int {
        tableDatabase.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableDatabase.sections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableCell(at: indexPath).create(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableCell(at: indexPath).click(tableView, didSelectRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableCell(at: indexPath).height(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableHeader(at: section).create(tableView, viewForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableHeader(at: section).height(tableView, heightForHeaderInSection: section)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoading else { return }
        
        let contentOffsetMaxY = Float(
            scrollView.contentOffset.y + scrollView.bounds.size.height
        )
        let contentHeight = Float(scrollView.contentSize.height)

        let delta = contentOffsetMaxY > contentHeight - 100
        guard delta else { return }
        
        loadResource?(true)
    }
    
    private func tableCell(at indexPath: IndexPath) -> TableCellController {
        tableDatabase.sections[indexPath.section].cells[indexPath.row]
    }
    
    private func tableHeader(at section: Int) -> TableHeaderController {
        tableDatabase.sections[section].header
    }
}

extension TableViewController: ContentTableView {
    func display(append viewData: TableViewData) {
        append(viewData.sections)
    }
    
    func display(update viewData: TableViewData) {
        update(viewData.sections)
    }
}

extension TableViewController: ErrorTableView {
    func display(_ viewData: ErrorViewData) {
        let errorHeaderController = NoneTableHanderController()
        let errorCellController = ErrorTableCellController(retry: viewData.tryAgainAction)
        update([TableSection(
            header: errorHeaderController,
            cells: [errorCellController]
        )])
    }
}

extension TableViewController: LoaderTableView {
    func display(_ viewData: LoadingViewData) {
        if viewData.isLoading {
            let loaderSpinner = LoaderSpinner()
            loaderSpinner.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 55)
            tableView.tableFooterView = loaderSpinner
            loaderSpinner.startAnimating()
        } else {
            tableView.tableFooterView = nil
        }
    }
}

extension TableViewController: RetryTableView {
    func display(_ viewData: ReloadViewData) {
        let reloadButton = RealodButton(action: viewData.tryToLoadAgain)
        reloadButton.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 55)
        tableView.tableFooterView = reloadButton
    }
}
