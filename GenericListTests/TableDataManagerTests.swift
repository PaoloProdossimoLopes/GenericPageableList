import XCTest

@testable import GenericList

final class TableDataManagerTests: XCTestCase {
    func testShouldNotHaveSectionsOnInit() {
        let sut = TableDataManager()
        XCTAssertEqual(sut.sections.count, 0)
    }
    
    func testShouldNotHaveSectionsOnAppendEmptySections() {
        let sut = TableDataManager()
        
        sut.appendSections([])
        
        XCTAssertEqual(sut.sections.count, 0)
    }
    
    func testShouldNotHaveSectionsOnUpdateToEmptySections() {
        let sut = TableDataManager()
        
        sut.updateSections([])
        
        XCTAssertEqual(sut.sections.count, 0)
    }
    
    func testShouldHaveOneSectionWhenUpdateWithOneSection() {
        let sut = TableDataManager()
        
        sut.updateSections([TableSection(header: TableHeaderControllerMock(), cells: [])])
        
        XCTAssertEqual(sut.sections.count, 1)
    }
    
    func testShouldHaveOneSectionWhenUpdateWithOneSectionTwice() {
        let sut = TableDataManager()
        
        sut.updateSections([TableSection(header: TableHeaderControllerMock(), cells: [])])
        sut.updateSections([TableSection(header: TableHeaderControllerMock(), cells: [])])
        
        XCTAssertEqual(sut.sections.count, 1)
    }
    
    func testShouldHaveOneSectionWhenAppendSection() {
        let sut = TableDataManager()
        
        sut.appendSections([TableSection(header: TableHeaderControllerMock(), cells: [])])
        
        XCTAssertEqual(sut.sections.count, 1)
    }
    
    func testShouldHaveTwoSectionWhenAppendOneSectionTwice() {
        let sut = TableDataManager()
        
        sut.appendSections([TableSection(header: TableHeaderControllerMock(), cells: [])])
        sut.appendSections([TableSection(header: TableHeaderControllerMock(), cells: [])])
        
        XCTAssertEqual(sut.sections.count, 2)
    }
    
    func testShouldHaveTwoSectionWhenAppendThreeTimesForTwoSameId() {
        let id = UUID().uuidString
        let sut = TableDataManager()
        
        sut.appendSections([TableSection(header: TableHeaderControllerMock(id: id), cells: [])])
        sut.appendSections([TableSection(header: TableHeaderControllerMock(), cells: [])])
        sut.appendSections([TableSection(header: TableHeaderControllerMock(id: id), cells: [])])
        
        XCTAssertEqual(sut.sections.count, 2)
    }
    
    func testSectionIdIsTheSameAppended() {
        let id = UUID().uuidString
        let sut = TableDataManager()
        let secondHeader = TableHeaderControllerMock()
        
        sut.appendSections([TableSection(header: TableHeaderControllerMock(id: id), cells: [])])
        sut.appendSections([TableSection(header: secondHeader, cells: [])])
        sut.appendSections([TableSection(header: TableHeaderControllerMock(id: id), cells: [])])
        
        XCTAssertEqual(sut.sections.first?.header.id, id)
        XCTAssertEqual(sut.sections.last?.header.id, secondHeader.id)
    }
    
    func testShouldAppendCellsSeparatedForTheSameSectionId() {
        let id = UUID().uuidString
        let sut = TableDataManager()
        let secondHeader = TableHeaderControllerMock()
        
        sut.appendSections([TableSection(header: TableHeaderControllerMock(id: id), cells: [
            TableCellControllerMock()
        ])])
        sut.appendSections([TableSection(header: secondHeader, cells: [TableCellControllerMock()])])
        sut.appendSections([TableSection(header: TableHeaderControllerMock(id: id), cells: [
            TableCellControllerMock(),
            TableCellControllerMock(),
            TableCellControllerMock()
        ])])
        
        XCTAssertEqual(sut.sections.first?.cells.count, 4)
        XCTAssertEqual(sut.sections.last?.cells.count, 1)
    }
    
    func testShouldHaveThreeSectionsWhenAppendForMultiplesCells() {
        let id = UUID().uuidString
        let sut = TableDataManager()
        let secondHeader = TableHeaderControllerMock()
        
        sut.appendSections([TableSection(header: TableHeaderControllerMock(), cells: [TableCellControllerMock()])])
        sut.appendSections([TableSection(header: TableHeaderControllerMock(id: id), cells: [
            TableCellControllerMock()
        ])])
        sut.appendSections([TableSection(header: secondHeader, cells: [TableCellControllerMock()])])
        sut.appendSections([TableSection(header: TableHeaderControllerMock(id: id), cells: [
            TableCellControllerMock(),
            TableCellControllerMock(),
            TableCellControllerMock()
        ])])
        
        XCTAssertEqual(sut.sections.count, 3)
        
        XCTAssertEqual(sut.sections.first?.cells.count, 1)
        
        XCTAssertEqual(sut.sections[1].cells.count, 4)
        
        XCTAssertEqual(sut.sections.last?.cells.count, 1)
    }
    
    func testShouldHaveOneSectionWithCorrectDatasWhenUpdateSectionAfterAppends() {
        let id = UUID().uuidString
        let sut = TableDataManager()
        sut.appendSections([TableSection(header: TableHeaderControllerMock(), cells: [TableCellControllerMock()])])
        sut.appendSections([TableSection(header: TableHeaderControllerMock(id: id), cells: [
            TableCellControllerMock()
        ])])
        sut.appendSections([TableSection(header: TableHeaderControllerMock(), cells: [TableCellControllerMock()])])
        sut.appendSections([TableSection(header: TableHeaderControllerMock(id: id), cells: [
            TableCellControllerMock(),
            TableCellControllerMock(),
            TableCellControllerMock()
        ])])
        
        let updateId = UUID().uuidString
        sut.updateSections([TableSection(header: TableHeaderControllerMock(id: updateId), cells: [
            TableCellControllerMock(),
            TableCellControllerMock(),
            TableCellControllerMock()
        ])])
        
        XCTAssertEqual(sut.sections.count, 1)
        XCTAssertEqual(sut.sections.first?.header.id, updateId)
        XCTAssertEqual(sut.sections.first?.cells.count, 3)
    }
    
    func testShouldHaveFourSectionWithCorrectDatasWhenAppendMultiples() {
        let id = UUID().uuidString
        let sut = TableDataManager()
        sut.appendSections([TableSection(header: TableHeaderControllerMock(), cells: [TableCellControllerMock()])])
        sut.appendSections([TableSection(header: TableHeaderControllerMock(id: id), cells: [
            TableCellControllerMock()
        ])])
        sut.appendSections([
            TableSection(header: TableHeaderControllerMock(), cells: [TableCellControllerMock()]),
            TableSection(header: TableHeaderControllerMock(), cells: [TableCellControllerMock()]),
        ])
        
        XCTAssertEqual(sut.sections.count, 4)
    }
    
    func testShouldHaveFourSectionsWhenAppendSectionsWithMultiplesDatasAndDuplicatedIds() {
        let id = UUID().uuidString
        let sut = TableDataManager()
        sut.appendSections([.init(
            header: TableHeaderControllerMock(id: id),
            cells: [TableCellControllerMock()]
        )])
        sut.appendSections([TableSection(header: TableHeaderControllerMock(), cells: [
            TableCellControllerMock()
        ])])
        sut.appendSections([
            TableSection(header: TableHeaderControllerMock(), cells: [TableCellControllerMock()]),
            TableSection(header: TableHeaderControllerMock(), cells: [TableCellControllerMock()]),
            TableSection(header: TableHeaderControllerMock(id: id), cells: [TableCellControllerMock(), TableCellControllerMock()]),
        ])
        
        XCTAssertEqual(sut.sections.count, 4)
        XCTAssertEqual(sut.sections.first?.cells.count, 3)
    }
        
}
