import Foundation


final class TableViewModel<Model: MoreLoadable> {
    
    private var canLoadMore = true
    
    private let contentTableView: ContentTableView
    private let errorTableView: ErrorTableView
    private let loaderTableView: LoaderTableView
    private let retryTableView: RetryTableView
    private let tableRepository: TableRepositoring<Model>
    private let tableViewDataMapper: TableViewDataMapping<Model>
    
    init(
        contentTableView: ContentTableView, 
        errorTableView: ErrorTableView,
        loaderTableView: LoaderTableView,
        retryTableView: RetryTableView,
        tableRepository: TableRepositoring<Model>,
        tableViewDataMapper: TableViewDataMapping<Model>
    ) {
        self.contentTableView = contentTableView
        self.errorTableView = errorTableView
        self.loaderTableView = loaderTableView
        self.retryTableView = retryTableView
        self.tableRepository = tableRepository
        self.tableViewDataMapper = tableViewDataMapper
    }
    
    typealias TableView = (
        ContentTableView & ErrorTableView & 
        LoaderTableView & RetryTableView
    )
    convenience init(
        tableView: TableView,
        tableRepository: TableRepositoring<Model>,
        tableViewDataMapper: TableViewDataMapping<Model>
    ) {
        self.init(
            contentTableView: tableView,
            errorTableView: tableView,
            loaderTableView: tableView,
            retryTableView: tableView,
            tableRepository: tableRepository,
            tableViewDataMapper: tableViewDataMapper
        )
    }
    
    func loadResource(isLoadingMore: Bool) {
        guard canLoadMore else { return }
        
        loaderTableView.display(LoadingViewData(isLoading: true))
        tableRepository.request(TableRequest()) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let resource):
                self.canLoadMore = resource.canLoadMore
                
                if isLoadingMore {
                    self.contentTableView.display(append: self.tableViewDataMapper.map(resource))
                } else {
                    self.contentTableView.display(update: self.tableViewDataMapper.map(resource))
                }
                
                self.loaderTableView.display(LoadingViewData(isLoading: false))
            case .failure:
                self.canLoadMore = false
                self.loaderTableView.display(LoadingViewData(isLoading: false))
                if isLoadingMore {
                    self.retryTableView.display(ReloadViewData(tryToLoadAgain: { [weak self] in
                        guard let self else { return }
                        self.canLoadMore = true
                        self.loadResource(isLoadingMore: isLoadingMore)
                    }))
                } else {
                    self.errorTableView.display(ErrorViewData(tryAgainAction: { [weak self] in
                        guard let self else { return }
                        self.canLoadMore = true
                        self.loadResource(isLoadingMore: isLoadingMore)
                    }))
                }
            }
        }
    }
}
