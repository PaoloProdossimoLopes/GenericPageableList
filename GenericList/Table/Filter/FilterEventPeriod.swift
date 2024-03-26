import Foundation

enum FilterEventPeriod {
    case days(Int)
    case range(Date, Date)
}
