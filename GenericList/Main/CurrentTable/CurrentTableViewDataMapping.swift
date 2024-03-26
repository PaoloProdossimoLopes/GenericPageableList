import Foundation

final class CurrentTableViewDataMapping: TableViewDataMapping<CurrentTableResourceModel> {
    
    private let avaliationAvailablity: AvaliationAvaliabliting
    
    init(avaliationAvailablity: AvaliationAvaliabliting) {
        self.avaliationAvailablity = avaliationAvailablity
    }
    
    override func map(_ resource: CurrentTableResourceModel) -> TableViewData {
        let today = Date()
        var tableSectionViewData = [TableSection]()
        tableSectionViewData.append(makePeriodSection(resource: resource))
        tableSectionViewData.append(contentsOf: makeEventSections(
            today: today, resource: resource
        ))
        if !resource.canLoadMore {
            tableSectionViewData.append(makeFooterSection())
            
            if avaliationAvailablity.isAvaliationAvailable {
                tableSectionViewData.append(makeAvaliationSection())
            }
        }

        return TableViewData(sections: tableSectionViewData)
    }
    
    private func makePeriodSection(resource: CurrentTableResourceModel) -> TableSection {
        TableSection(header: PeriodTableHanderController(), cells: [])
    }
    
    private func makeEventSections(today: Date, resource: CurrentTableResourceModel) -> [TableSection] {
        let sectionDates = NSOrderedSet(array: resource.item.events
            .map { $0.date }).array
            .map { $0 as! Date }
        let eventSections = sectionDates.map { sectionDate in
            let isToday = today == sectionDate
            let headerViewData: TableHeaderController = isToday ? TodaySectionTableHanderController() : DaySectionTableHanderController()
            let itemsViewData: [TableCellController] = resource.item.events
                .filter { $0.date == sectionDate }
                .map { _ in EventItemTableCellController() }
            
            return TableSection(
                header: headerViewData,
                cells: itemsViewData
            )
        }
        return eventSections
    }
    
    private func makeFooterSection() -> TableSection {
        TableSection(header: NoneTableHanderController(), cells: [FooterTableCellController()])
    }
    
    private func makeAvaliationSection() -> TableSection {
        TableSection(header: NoneTableHanderController(), cells: [AvaliationTableCellController()])
    }
}
