import Foundation

enum Formatter {
    enum Date {
        static func american(_ date: Foundation.Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        
        static func fromAmerican(_ string: String) -> Foundation.Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.date(from: string)!
        }
    }
}
