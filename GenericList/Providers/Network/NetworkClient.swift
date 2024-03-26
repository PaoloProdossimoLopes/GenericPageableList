protocol NetworkPageable: Decodable, Equatable {
    var pagination: NetworkPagination? { get }
}

struct NetworkPagination: Decodable, Equatable {
    var nextPage: Int
    var totalPage: Int
}

protocol NetworkClient {
    
    typealias NetworkCompletion<NetworkModel: NetworkPageable> = CompletionWith<TableResult<NetworkModel>>
    
    func perform<NetworkModel: Decodable>(_ request: NetworkRequest, completion: @escaping NetworkCompletion<NetworkModel>)
}
