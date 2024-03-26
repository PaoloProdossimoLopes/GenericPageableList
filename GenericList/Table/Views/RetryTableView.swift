struct ReloadViewData {
    let tryToLoadAgain: Completion
}

protocol RetryTableView {
    func display(_ viewData: ReloadViewData)
}
