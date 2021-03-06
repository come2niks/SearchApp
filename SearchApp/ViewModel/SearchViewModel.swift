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

    /**
     This function accesses the UserDefaults and returns search queries array
     
     ## Important Notes ##
     1. This will retrive data from UserDefaults, but not return any string
     
     - Parameter completion: Perform any desired action after completion.
     */
    func getSearchQureies(completion: @escaping () -> Void) {
        searchQueries = UserDefaults.standard.stringArray(forKey: "searchQueriesArray") ?? [String]()
        completion()
    }
    
    /**
     This function saves search queries to user defaults
     
     ## Important Notes ##
     1. This will save search queries to UserDefaults
     
     - Parameter fromSearch: This is String.
     - Parameter completion: Perform any desired action after completion.
     */
    func saveSearchQueries(fromSearch: String, completion: @escaping () -> Void) {
        let defaults = UserDefaults.standard
        /// check if any previous queries available in user defaults
        if let queries = defaults.stringArray(forKey: "searchQueriesArray") {
            searchQueries = queries
            /// if we have more less than 10 search Queries then directly insert query to searchQueries array
            if queries.count >= 0 && queries.count < 10 {
                searchQueries = uniqueArray(array: searchQueries!, value: fromSearch)
            } else {
                /// else remove last object and insert query @ the start of the array
                searchQueries?.removeLast()
                searchQueries = uniqueArray(array: searchQueries!, value: fromSearch)
            }
        } else {
            /// if no queries available, directly add query to searchQueries array
            searchQueries = []
            searchQueries = uniqueArray(array: searchQueries!, value: fromSearch)
        }
        defaults.set(self.searchQueries, forKey: "searchQueriesArray")
        completion()
    }
    
    /**
     This function check if object is already present in array and returns unique array of string
     
     - Parameter array: This is array which needs to check.
     - Parameter value: This is value which needs to check in array.
     - Returns: The array of unique strings.
     */
    func uniqueArray(array: [String], value: String) -> [String] {
        var array = array
        if !array.contains(value) {
            array.insert(value, at: 0)
        }
        return array
    }
    
    // MARK: - values to display in our table view controller
    func numberOfItemsToDisplay() -> Int {
        return searchQueries?.count ?? 0
    }
    
    /**
     This function returns the query string
     
     - Parameter indexPath: This is IndexPath, which is used to search string in searchQueries array.
     - Returns: The search query string to display.
     */
    func queryStringToDisplay(for indexPath: IndexPath) -> String {
        return searchQueries?[indexPath.row] ?? ""
    }
    
    /**
     This function returns the selected string
     
     - Parameter indexPath: This is IndexPath, which is used to search string in searchQueries array.
     - Returns: The selected search query string.
     */
    func getSelectedSearchString(for indexPath: IndexPath) -> String {
        let searchString = searchQueries?[indexPath.row]
        searchQueries?.remove(at: indexPath.row)
        UserDefaults.standard.set(self.searchQueries, forKey: "searchQueriesArray")
        return searchString!
    }

}
