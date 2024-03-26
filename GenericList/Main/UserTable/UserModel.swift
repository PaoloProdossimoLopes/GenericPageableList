import Foundation

struct UserModel: MoreLoadable {
    let item: User
    var canLoadMore: Bool
    
    struct User: Equatable {
        let name: String
    }
}
