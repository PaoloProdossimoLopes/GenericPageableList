import Foundation

struct TableRequest: Equatable {
    var query: [String: String] = [:]
}

class TableRepositoring<Model: MoreLoadable> {
    typealias RequestCompletion = CompletionWith<TableResult<Model>>
    
    func request(_ tableRequest: TableRequest, completion: @escaping RequestCompletion) {
        fatalError("Override the 'request' method from 'TableRepositoring'")
    }
}
