final class TableDataManager: TableDataManaging {
    
    private(set) var sections = [TableSection]()
    
    func appendSections(_ newSections: [TableSection]) {
        newSections.forEach { section in
            guard let duplicatedSectionIndex = sections.firstIndex(where: {
                $0.header.id == section.header.id
            }) else {
                sections.append(section)
                return
            }
            
            sections[duplicatedSectionIndex].cells.append(contentsOf: section.cells)
        }
    }
    
    func updateSections(_ newSections: [TableSection]) {
        sections = newSections
    }
}
