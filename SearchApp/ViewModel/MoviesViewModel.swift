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

    // Define an apps property that will hold the data from the iTunes RSS top 100 free apps feed
    //This array is marked an optional (?) because we might not get back data from the iTunes API
    var movies: [MovieRecord]?
    let posterURL = "http://image.tmdb.org/t/p/w92"

    // This function is what directly accesses the apiClient to make the API call
    func getMovies(fromSearch: String, pageNumber: Int, completion: @escaping () -> Void) {
        if pageNumber == 1 {
            self.movies = nil
        }
        // call on the apiClient to fetch the apps
        networkManager.fetchMoviesList(fromSearch: fromSearch, pageNumber: pageNumber, completion: { (moviesList) in
            // Put this block on the main queue because our completion handler is where the data display code will happen and we don't want to block any UI code.
            if pageNumber == 1 && moviesList!.count > 0 {
                self.searchViewModel.saveSearchQueries(fromSearch: fromSearch, completion: {
                })
            }
            DispatchQueue.main.async {
                
                // assign our local apps array to our returned json
                if self.movies?.count == 0 || self.movies == nil {
                    self.movies = moviesList
                } else {
                    self.movies = self.movies! + moviesList!
                }
                // call our completion handler because it is in this completion that we will reload data in our view controller tableview
                completion()
            }
        })
    }

    // MARK: - values to display in our table view controller
    func numberOfItemsToDisplay(in section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func moviePosterUrlToDisplay(for indexPath: IndexPath) -> String {
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
