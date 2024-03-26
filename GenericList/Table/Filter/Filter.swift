struct Filter {
    var eventType: FilterEventType = .all
    var eventOrder: FilterEventOrder = .asc
    var eventPeriod: FilterEventPeriod = .days(7)
}
