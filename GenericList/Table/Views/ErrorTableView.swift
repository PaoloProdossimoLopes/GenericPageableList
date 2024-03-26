struct ErrorViewData {
    let tryAgainAction: Completion
}

protocol ErrorTableView {
    func display(_ viewData: ErrorViewData)
}
