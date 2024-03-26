struct LoadingViewData: Equatable {
    let isLoading: Bool
}

protocol LoaderTableView {
    func display(_ viewData: LoadingViewData)
}
