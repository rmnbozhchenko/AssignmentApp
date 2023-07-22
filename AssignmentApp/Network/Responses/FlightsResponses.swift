struct FlightsResponses: Decodable {
    let onewayItineraries: OnewayItineraries
}

extension FlightsResponses {
    struct OnewayItineraries: Decodable {
        let itineraries: [Itinerary]
    }

    struct Itinerary: Decodable {
        let id: String
        let duration: Int
        let cabinClasses: [String]
        let priceEur: PriceEur
        let bookingOptions: BookingOptions
        let provider: Provider
        let sector: Sector
    }

    struct BookingOptions: Decodable {
        let edges: [Edge]
    }

    struct Edge: Decodable {
        let node: Node
    }

    struct Node: Decodable {
        let bookingUrl: String
        let price: Price
    }

    struct Price: Decodable {
        let amount, formattedValue: String
    }

    struct PriceEur: Decodable {
        let amount: String
    }

    struct Provider: Decodable {
        let id, name, code: String
    }

    struct Sector: Decodable {
        let id: String
        let duration: Int
        let sectorSegments: [SectorSegment]
    }

    struct SectorSegment: Decodable {
        let segment: Segment
        let layover: Layover?
        let guarantee: String?
    }

    struct Layover: Decodable {
        let duration: Int
        let isBaggageRecheck: Bool
        let transferDuration: Int?
        let transferType: String?
    }

    struct Segment: Decodable {
        let id: String
        let duration: Int
        let type: String
        let code: String
        let source, destination: Destination
        let carrier: Provider
        let operatingCarrier: Provider?
    }

    struct Destination: Decodable {
        let utcTime, localTime: String
        let station: Station
    }

    struct Station: Decodable {
        let id, name, code: String
        let type: String
        let city: City
    }

    struct City: Decodable {
        let id, legacyId, name: String
        let country: Country
    }

    struct Country: Decodable {
        let id: String
        let name: String
    }
}
