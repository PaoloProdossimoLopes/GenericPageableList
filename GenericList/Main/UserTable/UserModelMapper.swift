import Foundation

final class UserModelMapper: TableResourceMapping<UserDto, UserModel> {
    override func map(_ dto: UserDto) -> UserModel {
        UserModel(item: UserModel.User(name: dto.name), canLoadMore: false)
    }
}
