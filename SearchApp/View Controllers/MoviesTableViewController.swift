//
//  MoviesTableViewController.swift
//  SearchApp
//
//  Created by Nikhilesh Walde on 22/03/2018.
//  Copyright © 2018 PrepayNation. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var searchController: UISearchController!
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    var searchQuery: String = ""
    
    @IBOutlet var moviesViewModel: MoviesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()

        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    func updateSearchResults(for searchController: UISearchController) {
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchQuery = searchBar.text!
        moviesViewModel.getMovies(fromSearch: searchQuery, pageNumber: 1) {
            self.isLoadingList = false
            self.tableView.reloadData()
        }
        searchController.searchResultsController?.dismiss(animated: true, completion: nil)
        searchController.searchResultsController?.view.isHidden = true
    }

    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func getListFromServer(_ pageNumber: Int){
        moviesViewModel.getMovies(fromSearch: searchQuery, pageNumber: pageNumber) {
            self.isLoadingList = false
            self.tableView.reloadData()
        }
    }
    
    func loadMoreItemsForList(){
        currentPage += 1
        getListFromServer(currentPage)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList && searchQuery != ""){
            self.isLoadingList = true
            self.loadMoreItemsForList()
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return moviesViewModel.numberOfItemsToDisplay(in: section)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)

        // Configure the cell...        
        cell.textLabel?.text = moviesViewModel.movieTitleToDisplay(for: indexPath)
        //8 -
        cell.detailTextLabel?.text = moviesViewModel.movieReleaseDateToDisplay(for: indexPath)
        
//        cell.imageView?.image = //! Image download async
        return cell
    }

}
