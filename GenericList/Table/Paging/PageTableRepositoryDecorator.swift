
final class PageTableRepositoryDecorator<Model: MoreLoadable>: TableRepositoring<Model> {

    private var page: Int? = 1
    private let decoratee: TableRepositoring<Model>
    
    init(_ decoratee: TableRepositoring<Model>) {
        self.decoratee = decoratee
    }
    
    override func request(_ request: TableRequest, completion: @escaping TableRepositoring<Model>.RequestCompletion) {
        guard let page else { return }
        
        var request = request
        request.query["page"] = String(page)
        request.query["page_size"] = String(100)
        decoratee.request(request) { [weak self] result in
            guard let self else { return }
            if case let .success(resourceModel) = result {
                if resourceModel.canLoadMore, let page = self.page {
                    self.page = page + 1
                } else {
                    self.page = nil
                }
            }
            completion(result)
        }
    }
}
