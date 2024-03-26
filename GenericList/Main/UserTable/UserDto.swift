import Foundation

struct UserDto: Decodable, NetworkPageable {
    let name: String
    var pagination: NetworkPagination?
}
