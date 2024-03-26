protocol TableDataManaging {
    var sections: [TableSection] { get }
    
    func appendSections(_ sections: [TableSection])
    func updateSections(_ sections: [TableSection])
}
