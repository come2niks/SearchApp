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
    
    //3 - Define an apps property that will hold the data from the iTunes RSS top 100 free apps feed
    //This array is marked an optional (?) because we might not get back data from the iTunes API
    var movies: [MovieRecord]?
    
    var movieRecordVM: [MovieRecordViewModel]?
    
    let posterURL = "http://image.tmdb.org/t/p/w92"
    
    //4 - This function is what directly accesses the apiClient to make the API call
    func getMovies(fromSearch:String, completion: @escaping () -> Void) {
        
        //5 - call on the apiClient to fetch the apps
        networkManager.fetchMoviesList(fromSearch: fromSearch, completion: { (moviesList) in
            //6 - Put this block on the main queue because our completion handler is where the data display code will happen and we don't want to block any UI code.
            DispatchQueue.main.async {
                
                //7 - assign our local apps array to our returned json
                self.movies = moviesList
                
                //8 - call our completion handler because it is in this completion that we will reload data in our view controller tableview
                completion()
            }

        })
    }

    // MARK: - values to display in our table view controller
    //9 -
    func numberOfItemsToDisplay(in section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func moviePosterUrlToDisplay(for indexPath: IndexPath) -> String {
        return posterURL + (movies?[indexPath.row].poster_path ?? "")
    }

    //10 -
    func movieTitleToDisplay(for indexPath: IndexPath) -> String {
        return movies?[indexPath.row].title ?? ""
    }
    
    //11 -
    func movieReleaseDateToDisplay(for indexPath: IndexPath) -> String {
        return movies?[indexPath.row].release_date ?? ""
    }
    

}
