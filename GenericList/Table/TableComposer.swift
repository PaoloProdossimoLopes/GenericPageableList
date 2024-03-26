
enum TableComposer {
    static func compose<Model: MoreLoadable>(
        tableRepository: TableRepositoring<Model>,
        tableViewDataMapper: TableViewDataMapping<Model>
    ) -> TableViewController {
        let tableDatabase = TableDataManager()
        let tableViewController = TableViewController(
            tableDatabase: tableDatabase
        )
        let tableViewModel = TableViewModel<Model>(
            tableView: tableViewController,
            tableRepository: tableRepository,
            tableViewDataMapper: tableViewDataMapper
        )
        
        tableViewController.loadResource = tableViewModel.loadResource
        
        return tableViewController
    }
}
