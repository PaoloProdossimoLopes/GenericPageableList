@testable import GenericList

final class TableViewDataMappingMock: TableViewDataMapping<MoreLoadableMock> {
    
    private(set) var models = [MoreLoadableMock]()
    
    var mapStub = TableViewData(sections: [])
    
    override func map(_ model: MoreLoadableMock) -> TableViewData {
        models.append(model)
        return mapStub
    }
}
