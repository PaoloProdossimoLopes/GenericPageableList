@testable import GenericList

final class NetworkClientMock: NetworkClient {
    
    struct Perform {
        let request: NetworkRequest
        let completion: NetworkCompletion<NetworkPageableMock>
    }
    
    private(set) var performs = [Perform]()
    
    func perform<NetworkModel: NetworkPageable>(_ request: NetworkRequest, completion: @escaping NetworkCompletion<NetworkModel>) {
        performs.append(Perform(request: request, completion: { result in
            completion(result.map { $0 as! NetworkModel })
        }))
    }
    
    func completeWithSuccess(_ dto: NetworkPageableMock = makeAnyNetworkPageableMock(), at index: Int = 0) {
        performs[index].completion(.success(dto))
    }
    
    func completeWithFailure(_ error: TableError = makeAnyTableError(), at index: Int = 0) {
        performs[index].completion(.failure(error))
    }
}
