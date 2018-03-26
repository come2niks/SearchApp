//
//  SearchViewModel.swift
//  SearchApp
//
//  Created by Nikhilesh Walde on 26/03/2018.
//  Copyright © 2018 PrepayNation. All rights reserved.
//

import UIKit

class SearchViewModel: NSObject {

    var searchQueries: [String]?

    func getSearchQureies(completion: @escaping () -> Void) {
        searchQueries = UserDefaults.standard.stringArray(forKey: "searchQueriesArray") ?? [String]()

        completion()
    }
    
    // MARK: - values to display in our table view controller
    func numberOfItemsToDisplay(in section: Int) -> Int {
        return searchQueries?.count ?? 0
    }
    
    func queryStringToDisplay(for indexPath: IndexPath) -> String {
        return searchQueries?[indexPath.row] ?? ""
    }
    
    func searchStringSelected(for indexPath: IndexPath) -> String {
        let searchString = searchQueries?[indexPath.row]
        searchQueries?.remove(at: indexPath.row)
        UserDefaults.standard.set(self.searchQueries, forKey: "searchQueriesArray")
        return searchString!
    }

}
