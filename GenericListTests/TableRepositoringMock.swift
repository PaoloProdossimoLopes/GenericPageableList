@testable import GenericList

final class TableRepositoringMock: TableRepositoring<MoreLoadableMock> {
    
    struct Request {
        let tableRequest: TableRequest
        let completion: TableRepositoring<MoreLoadableMock>.RequestCompletion
    }
    
    private(set) var requests = [Request]()
    
    override func request(_ tableRequest: TableRequest, completion: @escaping TableRepositoring<MoreLoadableMock>.RequestCompletion) {
        requests.append(Request(tableRequest: tableRequest, completion: completion))
    }
    
    func completeWithFailure(_ error: TableError = makeAnyTableError(), at index: Int = 0) {
        requests[index].completion(.failure(error))
    }
    
    func completeWithSuccess(_ model: MoreLoadableMock = makeAnyMoreLoadable(), at index: Int = 0) {
        requests[index].completion(.success(model))
    }
}

