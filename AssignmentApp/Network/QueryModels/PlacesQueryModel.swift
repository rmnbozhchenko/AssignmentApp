import Foundation

struct PlacesQueryModel: ApiQueryModel {
    // Temporary impl for Query model
    
    /// Reflects how many places should be fetched from the API
    let first: Int
    
    var description: String {
        """
        query places {
            
            places(
                search: { term: "" },
                filter: {
                    onlyTypes: [AIRPORT, CITY],
                    groupByCity: true
                },
                options: { sortBy: RANK },
                first: \(first)
            ) {
                ... on PlaceConnection {
                    edges {
                        node {
                            id
                            legacyId
                            name
                            gps {
                                lat
                                lng
                            }
                        }
                    }
                }
            }
        }
        """
    }
}
