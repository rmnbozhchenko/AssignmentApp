import Foundation

struct PlacesQueryModel: ApiQueryModel {
    let term: String
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
