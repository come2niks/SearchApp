//
//  NetworkManager.swift
//  SearchApp
//
//  Created by Nikhilesh Walde on 23/03/2018.
//  Copyright © 2018 PrepayNation. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {

    func fetchMoviesList(fromSearch:String, completion: @escaping ([MovieRecord]?) -> Void) {
        
        //3 - unwrap our API endpoint https://rss.itunes.apple.com/api/v1/us/apple-music/hot-tracks/all/100/explicit.json
        guard let url = URL(string: "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=\(fromSearch)&page=1") else {
            print("Error unwrapping URL"); return }
        
        //4 - create a session and dataTask on that session to get data/response/error
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            //5 - unwrap our returned data
            guard let unwrappedData = data else { print("Error getting data"); return }
            
            do {
                //6 - create an object for our JSON data and cast it as a NSDictionary
                // .allowFragments specifies that the json parser should allow top-level objects that aren't NSArrays or NSDictionaries.

                if let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as? NSDictionary {

                    //7 - create an array of dictionaries from
                    if let movies = MoviesListObject(dictionary: responseJSON)?.movies {
                        
                        //8 - set the completion handler with our apps array of dictionaries
                        completion(movies)
                    }
                }
            } catch {
                //9 - if we have an error, set our completion with nil
                completion(nil)
                print("Error getting API data: \(error.localizedDescription)")
            }
        }
        //10 -
        dataTask.resume()
    }

}
