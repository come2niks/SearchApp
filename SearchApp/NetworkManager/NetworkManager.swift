//
//  NetworkManager.swift
//  SearchApp
//
//  Created by Nikhilesh Walde on 23/03/2018.
//  Copyright © 2018 PrepayNation. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {

    /**
     It fetches and returns the movies list for the query string with page number.
     
     ## Important Notes ##
     1. **fromSearch** parameter is **String**.
     2. **pageNumber** parameter is **Int**.
     3. Both parameters are compulsory.
     
     - Parameter fromSearch: The first parameter is String.
     - Parameter pageNumber: The second parameter is Int.
     - Parameter completion: The third parameter is completion handler.
     */
    func fetchMoviesList(fromSearch: String, pageNumber: Int, completion: @escaping ([MovieRecord]?) -> Void) {
        /// Property that will hold the server url
        let server_url = Bundle.main.object(forInfoDictionaryKey: "SERVER_URL") ?? ""
        /// Property that will hold the API key
        let api_key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") ?? ""
        /// Unwrap API
        guard let url = URL(string: "\(server_url)?api_key=\(api_key)&query=\(fromSearch)&page=\(pageNumber)") else {
            print(NSLocalizedString("error_unwrapping_url", comment: "")); return }

        /// Create a session and dataTask for session to get data, response and error
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            /// Unwrap response data
            guard let unwrappedData = data else { print(NSLocalizedString("error_getting_data", comment: "")); return }
            
            do {
                /// Create an object for JSON data and cast it to NSDictionary
                /// .allowFragments specifies that the json parser should allow top-level objects that aren't NSArrays or NSDictionaries.
                if let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as? NSDictionary {

                    /// create an array of movies from
                    if let movies = MoviesListObject(dictionary: responseJSON)?.movies {
                        
                        /// Set the completion handler with our array of movies
                        completion(movies)
                    } else {
                        print(responseJSON.object(forKey: "status_message") as? String ?? "");
                    }
                }
            } catch {
                /// if we get an error, set completion with nil 
                completion(nil)
                print(String.localizedStringWithFormat(NSLocalizedString("error_getting_api", comment: ""), error.localizedDescription))
            }
        }
        /// resume the task
        dataTask.resume()
    }

}
