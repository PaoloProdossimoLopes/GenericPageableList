final class UserTableViewDataMapper: TableViewDataMapping<UserModel> {
    override func map(_ model: UserModel) -> TableViewData {
        if model.item.name.contains("b") {
            return TableViewData(sections: [])
        } else {
            return TableViewData(sections: [])
        }
    }
}
