//
//  MoviesTableViewController.swift
//  SearchApp
//
//  Created by Nikhilesh Walde on 22/03/2018.
//  Copyright © 2018 PrepayNation. All rights reserved.
//

import UIKit
import SDWebImage

class MoviesTableViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var searchController: UISearchController!
    var currentPage : Int = 0
    var isLoadingList : Bool = false
    var searchQuery: String = ""
    /// View Model for movies,
    /// it hides all the binding
    @IBOutlet var moviesViewModel: MoviesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     It setup search controller, initialze Search Results Controller and add SearchController in table header
     */
    func setupSearchController() {
        // Search controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultsController: SearchTableViewController = storyboard.instantiateViewController(withIdentifier: "searchResults") as! SearchTableViewController

        searchController = UISearchController(searchResultsController: resultsController )
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor(white: 0.9, alpha: 0.9)
        searchController.searchBar.placeholder = NSLocalizedString("search_bar_placeholder", comment: "")
        searchController.hidesNavigationBarDuringPresentation = true
        searchController!.searchBar.sizeToFit()
        
        definesPresentationContext = true
        tableView.tableHeaderView = self.searchController!.searchBar
    }
    
    // MARK: - Search Controller delegate methods
    func updateSearchResults(for searchController: UISearchController) {
    }

    func willPresentSearchController(_ searchController: UISearchController) {
        currentPage = 0
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }

    // MARK: - Search Bar delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchQuery = searchBar.text!
        self.isLoadingList = true
        /// Get movies list from search query string and perform necessary action on closure completion
        moviesViewModel.getMovies(fromSearch: searchQuery, pageNumber: 1) {
            let moviesCount = self.moviesViewModel.numberOfItemsToDisplay()
            if moviesCount == 0 {
                DispatchQueue.main.async {
                    self.showAlert( NSLocalizedString("search_result_error", comment: "") )
                }
            }
            self.isLoadingList = false
            self.tableView.reloadData()
        }
        searchController.searchResultsController?.dismiss(animated: true, completion: nil)
        searchController.searchResultsController?.view.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchQuery = ""
    }
    
    // MARK: - Pagination
    /**
     This function gets movies list from server for different pages if available
     
     - Parameter pageNumber: This parameter is Int and is the page number to fetch.
     - Parameter fromSearch: This parameter is String and is the search query string.
     */
    func getMoviesListFromServer(_ pageNumber: Int, fromSearch: String){
        moviesViewModel.getMovies(fromSearch: fromSearch, pageNumber: pageNumber) {
            self.isLoadingList = false
            self.tableView.reloadData()
        }
    }
    
    /**
     This function increments the current page number for search pagination and calls getListFromServer
     */
    func loadMoreItemsForList(){
        currentPage += 1
        getMoviesListFromServer(currentPage, fromSearch: searchQuery)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList && searchQuery != ""){
            self.isLoadingList = true
            self.loadMoreItemsForList()
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesViewModel.numberOfItemsToDisplay()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieRecordTableViewCell
        // Configure the cell...        
        cell.titleLabel?.text = moviesViewModel.movieTitleToDisplay(for: indexPath)
        cell.releaseDateLabel?.text = moviesViewModel.movieReleaseDateToDisplay(for: indexPath)
        cell.overviewLabel.text = moviesViewModel.movieOverviewToDisplay(for: indexPath)
        cell.posterImageView?.sd_setImage(with: URL.init(string: moviesViewModel.moviePosterUrlToDisplay(for: indexPath)), placeholderImage: UIImage.init(named: "Placeholder"))
        return cell
    }

    // MARK: - Utility methods
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
