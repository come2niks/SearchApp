//
//  MoviesViewModel.swift
//  SearchApp
//
//  Created by Nikhilesh Walde on 23/03/2018.
//  Copyright © 2018 PrepayNation. All rights reserved.
//

import UIKit

class MoviesViewModel: NSObject {

    @IBOutlet var networkManager: NetworkManager!
    @IBOutlet var searchViewModel: SearchViewModel!

    /// Define properties that will hold the movies data.
    /// This array is marked an optional (?) because we might not get back movies list
    var movies: [MovieRecord]?

    /**
     This function directly accesses the networkManager to make the API call
     It saves search query string if we get movies in response

     ## Important Notes ##
     1. **fromSearch** parameter is **String**.
     2. **pageNumber** parameter is **Int**.
     3. Both parameters are compulsory.
     
     - Parameter fromSearch: The first parameter is String.
     - Parameter pageNumber: The second parameter is Int.
     - Parameter completion: The third parameter is completion handler.
     */
    func getMovies(fromSearch: String, pageNumber: Int, completion: @escaping () -> Void) {
        if pageNumber == 1 {
            self.movies = nil
        }
        /// call networkManager to fetch the movies
        networkManager.fetchMoviesList(fromSearch: fromSearch, pageNumber: pageNumber, completion: { (moviesList) in
            /// save search query string if we get movies
            if pageNumber == 1 && moviesList!.count > 0 {
                self.searchViewModel.saveSearchQueries(fromSearch: fromSearch, completion: {
                })
            }
            /// Put this block on the main queue because our completion handler is where the data display code will happen and we don't want to block any UI code.
            DispatchQueue.main.async {
                
                /// assign movies array to local movies object or added another page data
                if self.movies?.count == 0 || self.movies == nil {
                    self.movies = moviesList
                } else {
                    self.movies = self.movies! + moviesList!
                }
                /// call our completion handler because it is in this completion that we will reload data in our view controller tableview
                completion()
            }
        })
    }

    // MARK: - values to display in our table view controller
    func numberOfItemsToDisplay() -> Int {
        return movies?.count ?? 0
    }
    
    func moviePosterUrlToDisplay(for indexPath: IndexPath) -> String {
        let posterURL = Bundle.main.object(forInfoDictionaryKey: "IMAGE_SERVER_URL") as? String ?? ""
        return posterURL + (movies?[indexPath.row].poster_path ?? "")
    }

    func movieTitleToDisplay(for indexPath: IndexPath) -> String {
        return movies?[indexPath.row].title ?? ""
    }
    
    func movieReleaseDateToDisplay(for indexPath: IndexPath) -> String {
        return movies?[indexPath.row].release_date ?? ""
    }
    
    func movieOverviewToDisplay(for indexPath: IndexPath) -> String {
        return movies?[indexPath.row].overview ?? ""
    }

}
