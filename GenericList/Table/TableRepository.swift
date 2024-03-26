import Foundation

final class TableRepository<Dto: NetworkPageable, Model: MoreLoadable>: TableRepositoring<Model> {
    
    private var isFetching = false
    
    private let endpoint: NetworkEndpoint
    private let networkClient: NetworkClient
    private let tableResourceMapper: TableResourceMapping<Dto, Model>
    
    init(
        endpoint: NetworkEndpoint,
        networkClient: NetworkClient,
        tableResourceMapper: TableResourceMapping<Dto, Model>
    ) {
        self.endpoint = endpoint
        self.networkClient = networkClient
        self.tableResourceMapper = tableResourceMapper
    }
    
    override func request(_ request: TableRequest, completion: @escaping RequestCompletion) {
        guard !isFetching else { return }
        
        isFetching = true
        
        let networkRequest = NetworkRequest(endpoint: endpoint, query: request.query)
        networkClient.perform(networkRequest) { [weak self] (result: TableResult<Dto>) in
            guard let self else { return }
            switch result {
            case .success(let resourceModel):
                completion(.success(self.tableResourceMapper.map(resourceModel)))
            case .failure(let error):
                completion(.failure(error))
            }
            
            self.isFetching = false
        }
    }
}
