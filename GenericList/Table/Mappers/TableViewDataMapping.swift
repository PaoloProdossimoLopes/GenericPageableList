class TableViewDataMapping<Model> {
    func map(_ model: Model) -> TableViewData {
        fatalError("Override the method 'map' to convert model into view data")
    }
}
