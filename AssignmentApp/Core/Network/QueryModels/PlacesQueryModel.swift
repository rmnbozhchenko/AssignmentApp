import Foundation

struct PlacesQueryModel: ApiQueryModel {
    /// Reflects search term for the fetched places from the API
    let term: String
    /// Reflects how many places should be fetched from the API
    let first: Int
    
    var description: String {
        """
        query places {
            places(
                search: { term: "\(term)" },
                filter: {
                    onlyTypes: [AIRPORT, CITY],
                    groupByCity: true
                },
                options: { sortBy: RANK },
                first: \(first)
            ) {
                ... on PlaceConnection {
                    edges { node { id legacyId name gps { lat lng } } }
                }
            }
        }
        """
    }
}
