struct TableViewData {
    let sections: [TableSection]
}

protocol ContentTableView {
    func display(append viewData: TableViewData)
    func display(update viewData: TableViewData)
}
