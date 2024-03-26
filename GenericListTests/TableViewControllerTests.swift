import XCTest
import UIKit

@testable import GenericList

final class TableViewControllerTests: XCTestCase {
    func testShouldNotPopulateLoadResourceWhenControllerBecameVisible() {
        let env = makeEnvironment()
        
        env.sut.becameVisible()
        
        XCTAssertNil(env.sut.loadResource)
    }
    
    func testShouldCallLoadResourceOnControllerBecameVisible() {
        let env = makeEnvironment()
        
        var isLoadMoreReceiveds = [Bool]()
        env.sut.loadResource = { isLoadMoreReceiveds.append($0) }
        
        env.sut.becameVisible()
        
        XCTAssertEqual(isLoadMoreReceiveds, [false])
    }
    
    func testOnlyUpdateSectionTriggerOnceWhenDisplayErrorViewData() {
        let env = makeEnvironment()
        
        env.sut.display(ErrorViewData {})
        
        XCTAssertEqual(env.tableDatabase.updateSectionsReceiveds.count, 1)
        XCTAssertEqual(env.tableDatabase.appendSectionsReceiveds.count, 0)
    }
    
    func testTableFooterViewIsSettedWhenDisplayLoaderViewDataLoading() {
        let env = makeEnvironment()
        
        env.sut.display(LoadingViewData(isLoading: true))
        
        XCTAssertNotNil(env.sut.tableView.tableFooterView)
    }
    
    func testTableFooterViewIsActiviryIndicatorWhenDisplayLoaderViewDataLoading() throws {
        let env = makeEnvironment()
        
        env.sut.display(LoadingViewData(isLoading: true))
        
        let spinnerView = try XCTUnwrap(env.sut.tableView.tableFooterView as? UIActivityIndicatorView)
        XCTAssertTrue(spinnerView.isAnimating)
        XCTAssertFalse(spinnerView.isHidden)
    }
    
    func testRemoveFooterViewWhenDisplayLoaderViewWhenNotLoading() throws {
        let env = makeEnvironment()
        env.sut.display(LoadingViewData(isLoading: true))
        
        env.sut.display(LoadingViewData(isLoading: false))
        
        XCTAssertNil(env.sut.tableView.tableFooterView)
    }
    
    func testLoadResourceEqualLoadingMoreResourceWhenScrollToBottom() throws {
        let env = makeEnvironment()
        var isLoadMoreReceiveds = [Bool]()
        env.sut.loadResource = { isLoadMoreReceiveds.append($0) }
        env.sut.becameVisible()
        let scrooView = UIScrollView()
        scrooView.bounds.size.height = 100
        scrooView.contentOffset.y = CGFloat(300)
        
        env.sut.scrollViewDidScroll(scrooView)
        
        XCTAssertEqual(isLoadMoreReceiveds, [false, true])
    }
    
    func testNotLoadResourceEqualLoadingMoreResourceWhenScrollToNearBottom() throws {
        let env = makeEnvironment()
        var isLoadMoreReceiveds = [Bool]()
        env.sut.loadResource = { isLoadMoreReceiveds.append($0) }
        env.sut.becameVisible()
        let scrooView = UIScrollView()
        scrooView.bounds.size.height = 0
        scrooView.contentSize.height = 100
        scrooView.contentOffset.y = CGFloat(0)
        
        env.sut.scrollViewDidScroll(scrooView)
        
        XCTAssertEqual(isLoadMoreReceiveds, [false])
    }
    
    private struct Environment {
        let tableDatabase: TableDatabasingMock
        let sut: TableViewController
    }
    
    private func makeEnvironment(file: StaticString = #filePath, line: UInt = #line) -> Environment {
        let tableDatabase = TableDatabasingMock()
        let sut = TableViewController(tableDatabase: tableDatabase)
        
        XCTAssertNotHaveMemoryLeak(sut, file: file, line: line)
        XCTAssertNotHaveMemoryLeak(tableDatabase, file: file, line: line)
        
        return Environment(tableDatabase: tableDatabase, sut: sut)
    }
}

extension UIViewController {
    func becameVisible() {
        loadViewIfNeeded()
        viewWillAppear(false)
        viewDidAppear(false)
    }
}

final class TableDatabasingMock: TableDataManaging {
    
    var sections = [TableSection]()
    
    private(set) var appendSectionsReceiveds = [[TableSection]]()
    private(set) var updateSectionsReceiveds = [[TableSection]]()
    
    func appendSections(_ sections: [TableSection]) {
        appendSectionsReceiveds.append(sections)
    }
    
    func updateSections(_ sections: [TableSection]) {
        updateSectionsReceiveds.append(sections)
    }
}
