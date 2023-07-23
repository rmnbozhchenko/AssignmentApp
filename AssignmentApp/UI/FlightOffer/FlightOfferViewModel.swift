import Foundation

struct FlightOfferViewModel: Identifiable {
    var id: String
    let title: String
    let subtitle: String
    let price: String
    let imageUrl: URL?
}

extension FlightsResponses {
    func mapToViewModels(imageUrlMaker: (String) -> URL?) -> [FlightOfferViewModel] {
        onewayItineraries.itineraries.compactMap {
            $0.mapToViewModel(imageUrlMaker: imageUrlMaker)
        }
    }
}

private enum Constants {
    static let arrowRightString = "->"
    static let emptyStringSeparator = ""
    static let spaceStringSeparator = " "
    static let dotStringSeparator = " · "
    static let stopsString: (Int) -> String = {
        $0 > 1 ? "\($0) stops" : "direct"
    }
    static let durationString: (Double) -> String = {
        String(format: "%.2f hours total", $0)
    }
    static let otherInfoString = "Other Info..."
}

private extension FlightsResponses.Itinerary {
    func mapToViewModel(imageUrlMaker: (String) -> URL?) -> FlightOfferViewModel? {
        guard let startStation = sector.sectorSegments.first?.segment.source.station,
              let endStation = sector.sectorSegments.last?.segment.destination.station,
              let priceString = bookingOptions.edges.first?.node.price.formattedValue else {
            return nil
        }
        
        let segments = sector.sectorSegments
        let stops = segments.count
        let duration = sector.duration
        
        let stopsArrowsString: String = Range(1...stops)
            .map { _ in Constants.arrowRightString }
            .joined(separator: Constants.emptyStringSeparator)
        let tripString = startStation.code
        + "\(Constants.spaceStringSeparator)\(stopsArrowsString)\(Constants.spaceStringSeparator)"
        + endStation.code
        
        let subtitle = [tripString,
                        Constants.stopsString(stops),
                        Constants.durationString(Double(duration) / 3600),
                        Constants.otherInfoString]
            .joined(separator: Constants.dotStringSeparator)
        
        return FlightOfferViewModel(id: id,
                                    title: startStation.city.name + " -> " + endStation.city.name,
                                    subtitle: subtitle,
                                    price: priceString,
                                    imageUrl: imageUrlMaker(endStation.city.legacyId))
    }
}
