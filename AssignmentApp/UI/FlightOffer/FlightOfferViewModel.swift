import Foundation

struct FlightOfferViewModel: Identifiable {
    var id: String
    let title: String
    let subtitle: String
    let price: String
    let imageUrl: URL?
}

extension FlightsResponses {
    func mapToViewModels() -> [FlightOfferViewModel] {
        onewayItineraries.itineraries.compactMap {
            $0.mapToViewModel()
        }
    }
}

private extension FlightsResponses.Itinerary {
    // I didn't use localisation here, in real project - I will.
    // Also I didn't create constants for the values
    
    func mapToViewModel() -> FlightOfferViewModel? {
        guard let startStation = sector.sectorSegments.first?.segment.source.station,
              let endStation = sector.sectorSegments.last?.segment.destination.station,
              let priceString = bookingOptions.edges.first?.node.price.formattedValue else {
            return nil
        }
        
        let segments = sector.sectorSegments
        let stops = segments.count
        let duration = sector.duration
        
        let stopsArrowsString: String = Range(1...stops).map { _ in "->" }.joined(separator: "")
        let tripString = startStation.code + " \(stopsArrowsString) " + endStation.code
        
        let stopsString = stops > 1 ? "\(stops) stops" : "direct"
        
        let durationString = "\(duration / 3600) hours total"
        
        let otherInfoString = "Other Info..."
        
        let subtitle = [tripString, stopsString, durationString, otherInfoString]
            .joined(separator: " · ")
        
        let imageUrlString = "https://images.kiwi.com/photos/600x600/\(endStation.city.legacyId).jpg"
        
        return FlightOfferViewModel(id: id,
                                    title: startStation.city.name + " -> " + endStation.city.name,
                                    subtitle: subtitle,
                                    price: priceString,
                                    imageUrl: URL(string: imageUrlString))
    }
}
