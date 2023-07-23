import Foundation

struct DepartureDate {
    let startDateString: String
    let endDateString: String
}

protocol DepartureDateFilter {
    func departureDate() -> DepartureDate
}

final class DepartureDateFilterImpl {
    private let dateFormatter: DateFormatter
    
    init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
}

private enum Constants {
    // Now start/end dates are constants,
    // but of course they could be used from the user input.
    static let startDate = Date()
    static let endDate = Date(timeIntervalSinceNow: 3600 * 24)
}

extension DepartureDateFilterImpl: DepartureDateFilter {
    func departureDate() -> DepartureDate {
        let startDate = Constants.startDate
        let endDate = Constants.endDate
        
        return DepartureDate(startDateString: dateFormatter.string(from: startDate),
                             endDateString: dateFormatter.string(from: endDate))
    }
}
