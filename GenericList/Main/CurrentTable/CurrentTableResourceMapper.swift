import Foundation

final class CurrentTableResourceMapper: TableResourceMapping<CurrentResourceModel, CurrentTableResourceModel> {
    
    override func map(_ model: CurrentResourceModel) -> CurrentTableResourceModel {
        CurrentTableResourceModel(
            item: .init(
                period: period(),
                events: events(model: model)
            ),
            canLoadMore: canLoadMore(model: model)
        )
    }
    
    private func period() -> CurrentTableResourceModel.Period {
        let startDatePeriod = Date()
        let endDatePeriod = Date()
        return CurrentTableResourceModel.Period(
            startDate: startDatePeriod,
            endDate: endDatePeriod
        )
    }
    
    private func events(model: CurrentResourceModel) -> [CurrentTableResourceModel.Event] {
        model.events.map { event in
            return CurrentTableResourceModel.Event(
                id: event.timestamp,
                date: Formatter.Date.fromAmerican(event.eventDate),
                shortDescription: event.shortDescription,
                longDescription: event.longDescription,
                amount: event.value,
                detail: detail(event: event)
            )
        }
    }
    
    private func detail(event: CurrentResourceModel.Event) -> CurrentTableResourceModel.Detail? {
        guard let transactionDetail = event.transactionDetail else {
            return nil
        }
        
        return CurrentTableResourceModel.Detail(
            agency: transactionDetail.agency,
            account: transactionDetail.account,
            dac: transactionDetail.dac
        )
    }
    
    private func canLoadMore(model: CurrentResourceModel) -> Bool {
        guard let pagination = model.pagination else {
            return false
        }
        
        return pagination.nextPage < pagination.totalPage
    }
}
