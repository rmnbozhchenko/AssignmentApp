import Foundation

struct FlightsQueryModel: ApiQueryModel {
    let limit: Int
    let currency: String
    let sources: [String]
    let destinations: [String]
    let departureStart: String
    let departureEnd: String
    
    var description: String {
        """
        fragment stopDetails on Stop {
          utcTime
          localTime
          station { id name code type city { id legacyId name country { id name } } }
        }
        query onewayItineraries {
          onewayItineraries(
            filter: {
              allowChangeInboundSource: false, allowChangeInboundDestination: false,
              allowDifferentStationConnection: true, allowOvernightStopover: true,
              contentProviders: [KIWI], limit: \(limit), showNoCheckedBags: true,
              transportTypes: [FLIGHT]
            }, options: {
              currency: "\(currency)", partner: "skypicker", sortBy: QUALITY,
              sortOrder: ASCENDING, sortVersion: 4, storeSearch: true
            }, search: {
              cabinClass: { applyMixedClasses: true, cabinClass: ECONOMY },
              itinerary: {
                source: { ids: \(sources) },
                destination: { ids: \(destinations) },
                outboundDepartureDate: {
                  start: "\(departureStart)",
                  end: "\(departureEnd)"
        } },
              passengers: { adults: 1, adultsHandBags: [1], adultsHoldBags: [0] }
            }
        ){
        ... on Itineraries {
              itineraries {
                ... on ItineraryOneWay {
                  id duration cabinClasses priceEur { amount }
                  bookingOptions {
        edges {
                      node { bookingUrl price { amount formattedValue } }
                    }
                  }
                  provider { id name code }
                  sector {
                    id duration
                    sectorSegments {
                      segment {
                        id duration type code
                        source { ...stopDetails }
                        destination { ...stopDetails }
                        carrier { id name code }
                        operatingCarrier { id name code }
                      }
                      layover { duration isBaggageRecheck transferDuration transferType }
                      guarantee
        } }
        } }
        } }
        }
        """
    }
}
