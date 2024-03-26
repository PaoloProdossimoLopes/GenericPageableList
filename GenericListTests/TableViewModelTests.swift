import XCTest

@testable import GenericList

final class TableViewModelTests: XCTestCase {
    func testInitNoTriggerAnyDependency() {
        let env = makeEnvironment()
        
        XCTAssertEqual(env.tableRepository.requests.count, 0)
        XCTAssertEqual(env.tableViewDataMapper.models.count, 0)
        XCTAssertEqual(env.contentTableView.appendViewDatas.count, 0)
        XCTAssertEqual(env.contentTableView.updateViewDatas.count, 0)
        XCTAssertEqual(env.errorTableView.displays.count, 0)
        XCTAssertEqual(env.loaderTableView.displays.count, 0)
        XCTAssertEqual(env.retryTableView.displays.count, 0)
        XCTAssertEqual(env.errorTableView.displays.count, 0)
    }
    
    func testLoadResourceDisplayLoading() {
        let env = makeEnvironment()
        
        env.sut.loadResource(isLoadingMore: false)
        
        XCTAssertEqual(env.loaderTableView.displays, [
            LoadingViewData(isLoading: true)
        ])
    }
    
    func testLoadResourceTwiceDisplayLoadingTwice() {
        let env = makeEnvironment()
        
        env.sut.loadResource(isLoadingMore: false)
        env.sut.loadResource(isLoadingMore: false)
        
        XCTAssertEqual(env.loaderTableView.displays, [
            LoadingViewData(isLoading: true),
            LoadingViewData(isLoading: true)
        ])
    }
    
    func testLoadResourceLoadingMoreDisplayLoading() {
        let env = makeEnvironment()
        
        env.sut.loadResource(isLoadingMore: true)
        
        XCTAssertEqual(env.loaderTableView.displays, [
            LoadingViewData(isLoading: true)
        ])
    }
    
    func testLoadResourceRequests() {
        let env = makeEnvironment()
        
        env.sut.loadResource(isLoadingMore: false)
        
        XCTAssertEqual(env.tableRepository.requests.count, 1)
    }
    
    func testLoadResourceTwiceRequestTwice() {
        let env = makeEnvironment()
        
        env.sut.loadResource(isLoadingMore: false)
        env.sut.loadResource(isLoadingMore: false)
        
        XCTAssertEqual(env.tableRepository.requests.count, 2)
    }
    
    func testLoadResourceLoadingMoreRequests() {
        let env = makeEnvironment()
        
        env.sut.loadResource(isLoadingMore: true)
        
        XCTAssertEqual(env.tableRepository.requests.count, 1)
    }
    
    func testTableRepositoryCompletesWithFailureDisableLoader() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: false)
        
        env.tableRepository.completeWithFailure()
        
        XCTAssertEqual(env.loaderTableView.displays, [
            LoadingViewData(isLoading: true),
            LoadingViewData(isLoading: false),
        ])
    }
    
    func testHideLoaderWhenRepositoryCompletesWithFailureOnLoadMoreResource() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: true)
        
        env.tableRepository.completeWithFailure()
        
        XCTAssertEqual(env.loaderTableView.displays, [
            LoadingViewData(isLoading: true),
            LoadingViewData(isLoading: false),
        ])
    }
    
    func testTableRepositoryCompletesWithFailureDisplayErrorView() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: false)

        env.tableRepository.completeWithFailure()
        
        XCTAssertEqual(env.errorTableView.displays.count, 1)
    }
    
    func testDisplayRetryViewWhenRepositoryCompletesWithFailureOnLoadMoreResource() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: true)

        env.tableRepository.completeWithFailure()
        
        XCTAssertEqual(env.errorTableView.displays.count, 0)
        XCTAssertEqual(env.retryTableView.displays.count, 1)
    }
    
    func testLoadResourceIsNotLoadingMoreShouldNotRequestsAgain() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: false)
        env.tableRepository.completeWithFailure()
        
        env.sut.loadResource(isLoadingMore: false)
        
        XCTAssertEqual(env.tableRepository.requests.count, 1)
    }
    
    func testLoadResourceIsNotLoadingMoreShouldNotShowsLoader() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: false)
        env.tableRepository.completeWithFailure()
        
        env.sut.loadResource(isLoadingMore: false)
        
        XCTAssertEqual(env.loaderTableView.displays, [
            LoadingViewData(isLoading: true),
            LoadingViewData(isLoading: false)
        ])
    }
    
    func testTriggerTryAgainShouldRequestsAgain() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: false)
        env.tableRepository.completeWithFailure()
        
        env.errorTableView.displays.last?.tryAgainAction()
        
        XCTAssertEqual(env.tableRepository.requests.count, 2)
    }
    
    func testRetryActionShouldRequestAgainWhenLoadMoreResource() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: true)
        env.tableRepository.completeWithFailure()
        
        env.retryTableView.displays.last?.tryToLoadAgain()
        
        XCTAssertEqual(env.tableRepository.requests.count, 2)
    }
    
    func testTriggerTryAgainShouldDisplayLoader() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: false)
        env.tableRepository.completeWithFailure()
        
        env.errorTableView.displays.last?.tryAgainAction()
        
        XCTAssertEqual(env.loaderTableView.displays, [
            LoadingViewData(isLoading: true),
            LoadingViewData(isLoading: false),
            LoadingViewData(isLoading: true),
        ])
    }
    
    func testTriggerRequestAgainWhenLoadResourceAfterFailure() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: true)
        env.tableRepository.completeWithFailure()
        
        env.sut.loadResource(isLoadingMore: false)
        
        XCTAssertEqual(env.tableRepository.requests.count, 1)
    }
    
    func testNoDisplayLoaderWhenLoadResourceAfterFailure() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: false)
        env.tableRepository.completeWithFailure()
        
        env.sut.loadResource(isLoadingMore: false)
        
        XCTAssertEqual(env.loaderTableView.displays, [
            LoadingViewData(isLoading: true),
            LoadingViewData(isLoading: false)
        ])
    }
    
    func testTriggerRequestAgainWhenLoadMoreResourceAfterFailure() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: true)
        env.tableRepository.completeWithFailure()
        
        env.sut.loadResource(isLoadingMore: true)
        
        XCTAssertEqual(env.tableRepository.requests.count, 1)
    }
    
    func testNoDisplayLoaderWhenLoadMoreResourceAfterFailure() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: false)
        env.tableRepository.completeWithFailure()
        
        env.sut.loadResource(isLoadingMore: true)
        
        XCTAssertEqual(env.loaderTableView.displays, [
            LoadingViewData(isLoading: true),
            LoadingViewData(isLoading: false)
        ])
    }
    
    func testShouldHideLoaderWhenRepositoryCompleteWithSuccessOnLoadResource() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: false)
        
        env.tableRepository.completeWithSuccess()
        
        XCTAssertEqual(env.loaderTableView.displays, [
            LoadingViewData(isLoading: true),
            LoadingViewData(isLoading: false)
        ])
    }
    
    func testShouldAppendViewDataWhenRepositoryCompletesWithSuccessOnLoadResource() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: false)
        
        env.tableRepository.completeWithSuccess()
        
        XCTAssertEqual(env.contentTableView.appendViewDatas.count, 0)
        XCTAssertEqual(env.contentTableView.updateViewDatas.count, 1)
    }
    
    func testShouldUpdateViewDataWhenRepositoryCompletesWithSuccessOnLoadMoreResource() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: true)
        
        env.tableRepository.completeWithSuccess()
        
        XCTAssertEqual(env.contentTableView.appendViewDatas.count, 1)
        XCTAssertEqual(env.contentTableView.updateViewDatas.count, 0)
    }
    
    func testShouldUpdateAndAppendWhenCompleteWithSuccessAndLoadResource() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: true)
        env.tableRepository.completeWithSuccess()
        env.sut.loadResource(isLoadingMore: false)
        
        env.tableRepository.completeWithSuccess(at: 1)
        
        XCTAssertEqual(env.contentTableView.appendViewDatas.count, 1)
        XCTAssertEqual(env.contentTableView.updateViewDatas.count, 1)
    }
    
    func testShouldUpdateAndAppendWhenCompleteWithSuccessAndLoadMoreResource() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: false)
        env.tableRepository.completeWithSuccess()
        env.sut.loadResource(isLoadingMore: true)
        
        env.tableRepository.completeWithSuccess(at: 1)
        
        XCTAssertEqual(env.contentTableView.appendViewDatas.count, 1)
        XCTAssertEqual(env.contentTableView.updateViewDatas.count, 1)
    }
    
    func testRequestsCanNotLoadMoreResourceWhenRepositoryCompleteAsCanNotLoadMore() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: false)
        env.tableRepository.completeWithSuccess(makeAnyMoreLoadable(canLoadMore: false))
        env.sut.loadResource(isLoadingMore: true)
        
        XCTAssertEqual(env.tableRepository.requests.count, 1)
    }
    
    func testRequestsCanLoadMoreResourceWhenRepositoryCompleteAsCanLoadMore() {
        let env = makeEnvironment()
        env.sut.loadResource(isLoadingMore: false)
        env.tableRepository.completeWithSuccess(makeAnyMoreLoadable(canLoadMore: true))
        env.sut.loadResource(isLoadingMore: true)
        
        XCTAssertEqual(env.tableRepository.requests.count, 2)
    }
}

extension TableViewModelTests {
    private struct Environment {
        let contentTableView: ContentTableViewSpy
        let errorTableView: ErrorTableViewSpy
        let loaderTableView: LoaderTableViewSpy
        let retryTableView: RetryTableViewSpy
        let tableRepository: TableRepositoringMock
        let tableViewDataMapper: TableViewDataMappingMock
        let sut: TableViewModel<MoreLoadableMock>
    }
    
    private func makeEnvironment() -> Environment {
        let contentTableView = ContentTableViewSpy()
        let errorTableView = ErrorTableViewSpy()
        let loaderTableView = LoaderTableViewSpy()
        let retryTableView = RetryTableViewSpy()
        let tableRepository = TableRepositoringMock()
        let tableViewDataMapper = TableViewDataMappingMock()
        let sut = TableViewModel(
            contentTableView: contentTableView,
            errorTableView: errorTableView,
            loaderTableView: loaderTableView,
            retryTableView: retryTableView,
            tableRepository: tableRepository,
            tableViewDataMapper: tableViewDataMapper
        )
        
        XCTAssertNotHaveMemoryLeak(contentTableView)
        XCTAssertNotHaveMemoryLeak(loaderTableView)
        XCTAssertNotHaveMemoryLeak(errorTableView)
        XCTAssertNotHaveMemoryLeak(retryTableView)
        XCTAssertNotHaveMemoryLeak(tableRepository)
        XCTAssertNotHaveMemoryLeak(tableViewDataMapper)
        XCTAssertNotHaveMemoryLeak(sut)
        
        return Environment(
            contentTableView: contentTableView,
            errorTableView: errorTableView,
            loaderTableView: loaderTableView,
            retryTableView: retryTableView,
            tableRepository: tableRepository,
            tableViewDataMapper: tableViewDataMapper,
            sut: sut
        )
    }
}
