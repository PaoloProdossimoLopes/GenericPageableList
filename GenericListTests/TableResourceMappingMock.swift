@testable import GenericList

final class TableResourceMappingMock: TableResourceMapping<NetworkPageableMock, MoreLoadableMock> {
    
    private(set) var dtos = [NetworkPageableMock]()
    var mapStub = makeAnyMoreLoadable()
    
    override func map(_ dto: NetworkPageableMock) -> MoreLoadableMock {
        dtos.append(dto)
        return mapStub
    }
}
