import XCTest

@testable import GenericList

final class TableRepositoryTests: XCTestCase {
    func testShouldCallNeworkOnceWhenRequestOnce() {
        let env = makeEnvironment()
        
        env.sut.request(TableRequest()) { _ in }
        
        XCTAssertEqual(env.networkClient.performs.count, 1)
    }
    
    func testShouldNotCallNetworkTwiceIfClientNotCompletesTheOperation() {
        let env = makeEnvironment()
        
        env.sut.request(TableRequest()) { _ in }
        env.sut.request(TableRequest()) { _ in }
        
        XCTAssertEqual(env.networkClient.performs.count, 1)
    }
    
    func testShouldCallNetworkWithCurrentEndpoint() {
        let endpoint = NetworkEndpoint.current
        let env = makeEnvironment(endpoint: endpoint)
        
        env.sut.request(TableRequest()) { _ in }
        
        XCTAssertEqual(env.networkClient.performs.first?.request.endpoint, endpoint)
    }
    
    func testShouldCallNetworkWithCashFlowEndpoint() {
        let endpoint = NetworkEndpoint.cashFlow
        let env = makeEnvironment(endpoint: endpoint)
        
        env.sut.request(TableRequest()) { _ in }
        
        XCTAssertEqual(env.networkClient.performs.first?.request.endpoint, endpoint)
    }
    
    func testShouldCallNetworkWithQueryPassingFromQuest() {
        let queryParams = ["any_key": "any_value"]
        let env = makeEnvironment()
        
        env.sut.request(TableRequest(query: queryParams)) { _ in }
        
        XCTAssertEqual(env.networkClient.performs.first?.request.query, queryParams)
    }
    
    func testShouldCallNetworkWithNoQueryPassingFromQuest() {
        let env = makeEnvironment()
        
        env.sut.request(TableRequest(query: [:])) { _ in }
        
        XCTAssertEqual(env.networkClient.performs.first?.request.query, [:])
    }
    
    func testShouldCallNewtorkAgainWhenPerformAfterCompltesWithFailure() {
        let env = makeEnvironment()
        env.sut.request(TableRequest()) { _ in }
        env.networkClient.completeWithFailure()
        
        env.sut.request(TableRequest()) { _ in }
        
        XCTAssertEqual(env.networkClient.performs.count, 2)
    }
    
    func testShouldCallNewtorkAgainWithCorrectWhenPerformAfterCompltesWithFailure() {
        let endpoint = NetworkEndpoint.consolidate
        let query = ["key": "value"]
        let env = makeEnvironment(endpoint: endpoint)
        env.sut.request(TableRequest()) { _ in }
        env.networkClient.completeWithFailure()
        
        env.sut.request(TableRequest(query: query)) { _ in }
        
        XCTAssertEqual(env.networkClient.performs.last?.request, NetworkRequest(endpoint: endpoint, query: query))
    }
    
    func testShouldCompleteOnceWhenPerformAfterCompltesWithFailure() {
        var requestCompletions = [TableResult<MoreLoadableMock>]()
        let env = makeEnvironment()
        env.sut.request(TableRequest()) { requestCompletions.append($0) }
        
        env.networkClient.completeWithFailure()
        
        XCTAssertEqual(requestCompletions.count, 1)
    }
    
    func testShouldPassTheErrorWhenPerformAfterCompltesWithFailure() throws {
        let tableError = makeAnyTableError()
        var requestCompletions = [TableResult<MoreLoadableMock>]()
        let env = makeEnvironment()
        env.sut.request(TableRequest()) { requestCompletions.append($0) }
        
        env.networkClient.completeWithFailure(tableError)
        
        let result = try XCTUnwrap(requestCompletions.first)
        switch result {
        case .success:
            XCTFail("Expect to recieve an error, but recieve an success instead.")
        case .failure(let recievedError):
            XCTAssertEqual(recievedError, tableError)
        }
    }
    
    func testCallMapperWithCorrectDtoWhenPerformAfterCompltesWithFailure() throws {
        let pageble = makeAnyNetworkPageableMock()
        var requestCompletions = [TableResult<MoreLoadableMock>]()
        let env = makeEnvironment()
        env.sut.request(TableRequest()) { requestCompletions.append($0) }
        
        env.networkClient.completeWithSuccess(pageble)
        
        XCTAssertEqual(env.tableResourceMapper.dtos, [pageble])
    }
    
    func testCompleteWithModelProvidedByMapperWhenPerformAfterCompltesWithFailure() throws {
        let tableModel = makeAnyMoreLoadable(item: "any valid more loader", canLoadMore: Bool.random())
        let env = makeEnvironment()
        env.tableResourceMapper.mapStub = tableModel
        var requestCompletions = [TableResult<MoreLoadableMock>]()
        env.sut.request(TableRequest()) { requestCompletions.append($0) }
        
        env.networkClient.completeWithSuccess()
        
        let result = try XCTUnwrap(requestCompletions.first)
        switch result {
        case .success(let recievedModel):
            XCTAssertEqual(recievedModel, tableModel)
        case .failure(let recievedError):
            XCTFail("Expect to recieve an success case with \(tableModel) model instead of error with \(recievedError)")
        }
    }
    
    func testShouldCompleteOnceWhenPerformAfterCompltesWithSuccess() {
        var requestCompletions = [TableResult<MoreLoadableMock>]()
        let env = makeEnvironment()
        env.sut.request(TableRequest()) { requestCompletions.append($0) }
        
        env.networkClient.completeWithSuccess()
        
        XCTAssertEqual(requestCompletions.count, 1)
    }
    
    func testShouldCallNewtorkAgainWhenPerformAfterCompltesWithSuccess() {
        let env = makeEnvironment()
        env.sut.request(TableRequest()) { _ in }
        env.networkClient.completeWithSuccess()
        
        env.sut.request(TableRequest()) { _ in }
        
        XCTAssertEqual(env.networkClient.performs.count, 2)
    }
    
    private struct Environment {
        let networkClient: NetworkClientMock
        let tableResourceMapper: TableResourceMappingMock
        let sut: TableRepository<NetworkPageableMock, MoreLoadableMock>
    }
    
    private func makeEnvironment(
        endpoint: NetworkEndpoint = .current,
        file: StaticString = #filePath, line: UInt = #line
    ) -> Environment {
        let networkClient = NetworkClientMock()
        let tableResourceMapper = TableResourceMappingMock()
        let sut = TableRepository(
            endpoint: endpoint,
            networkClient: networkClient,
            tableResourceMapper: tableResourceMapper
        )
        
        XCTAssertNotHaveMemoryLeak(sut, file: file, line: line)
        XCTAssertNotHaveMemoryLeak(tableResourceMapper, file: file, line: line)
        XCTAssertNotHaveMemoryLeak(networkClient, file: file, line: line)
        
        return Environment(
            networkClient: networkClient,
            tableResourceMapper: tableResourceMapper,
            sut: sut
        )
    }
}
