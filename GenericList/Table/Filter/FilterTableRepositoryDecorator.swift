import Foundation

final class FilterTableRepositoryDecorator<Model: MoreLoadable>: TableRepositoring<Model> {
    
    private var filter = Filter()
    private let decoratee: TableRepositoring<Model>
    
    init(_ decoratee: TableRepositoring<Model>) {
        self.decoratee = decoratee
    }
    
    override func request(_ tableRequest: TableRequest, completion: @escaping TableRepositoring<Model>.RequestCompletion) {
        var request = tableRequest
        
        request.query["event_type"] = String(filter.eventType.rawValue)
        request.query["event_order"] = String(filter.eventOrder.rawValue)
        
        switch filter.eventPeriod {
        case .days(let numberOfDays):
            request.query["event_period"] = String(numberOfDays)
        case let .range(startDate, endDate):
            request.query["event_initial_date"] = String(Formatter.Date.american(startDate))
            request.query["event_final_date"] = String(Formatter.Date.american(endDate))
        }
        
        decoratee.request(request, completion: completion)
    }
    
    func update(_ newFilter: Filter) {
        filter = newFilter
    }
}
