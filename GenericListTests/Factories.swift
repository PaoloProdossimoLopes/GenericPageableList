@testable import GenericList

func makeAnyMoreLoadable(item: String = String(), canLoadMore: Bool = true) -> MoreLoadableMock {
    MoreLoadableMock(item: item, canLoadMore: canLoadMore)
}

func makeAnyTableError() -> TableError {
    TableError()
}

func makeAnyNetworkPageableMock() -> NetworkPageableMock {
    NetworkPageableMock(pagination: NetworkPagination(nextPage: 1, totalPage: 2))
}
