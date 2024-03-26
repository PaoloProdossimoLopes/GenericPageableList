class TableResourceMapping <Dto: Decodable, Model: MoreLoadable> {
    func map(_ dto: Dto) -> Model {
        fatalError("Override the method 'map' to convert into your pageable model")
    }
}
