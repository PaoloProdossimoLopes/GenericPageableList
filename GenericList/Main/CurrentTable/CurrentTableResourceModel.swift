import Foundation

protocol MoreLoadable: Equatable {
    associatedtype Item
    var item: Item { get }
    var canLoadMore: Bool { get }
}

struct CurrentTableResourceModel: Equatable, MoreLoadable {
    let item: Item
    let canLoadMore: Bool
    
    struct Item: Equatable {
        let period: Period
        let events: [Event]
    }
    
    struct Period: Equatable {
        let startDate: Date
        let endDate: Date
    }
    
    struct Event: Equatable {
        let id: String
        let date: Date
        let shortDescription: String
        let longDescription: String
        let amount: Double
        let detail: Detail?
    }
    
    struct Detail: Equatable {
        let agency: String
        let account: String
        let dac: String
    }
}
