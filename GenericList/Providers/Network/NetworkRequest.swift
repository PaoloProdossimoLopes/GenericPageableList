struct NetworkRequest: Equatable {
    let endpoint: NetworkEndpoint
    var query: [String: String]
}
