//
//  MovieRecordViewModel.swift
//  SearchApp
//
//  Created by Nikhilesh Walde on 23/03/2018.
//  Copyright © 2018 PrepayNation. All rights reserved.
//

import UIKit

class MovieRecordViewModel: NSObject {

    var movie: MovieRecord?
    let posterURL = "http://image.tmdb.org/t/p/w92"

    func moviePosterUrlToDisplay() -> String {
        return posterURL + (movie?.poster_path ?? "")
    }
    
    //10 -
    func movieTitleToDisplay() -> String {
        return movie?.title ?? ""
    }
    
    //11 -
    func movieReleaseDateToDisplay() -> String {
        return movie?.release_date ?? ""
    }
    

}
