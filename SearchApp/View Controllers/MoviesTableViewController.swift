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
    
    var models = [Model]()
    var filteredModels = [Model]()
    
    @IBOutlet var moviesViewModel: MoviesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        moviesViewModel.getMovies {
//            self.tableView.reloadData()
//        }

        setupSearchController()

        tableView.tableFooterView = UIView()
        
        models = [
            Model(movie:"The Dark Night", genre:"Action"),
            Model(movie:"The Avengers", genre:"Action"),
            Model(movie:"Logan", genre:"Action"),
            Model(movie:"Shutter Island", genre:"Thriller"),
            Model(movie:"Inception", genre:"Thriller"),
            Model(movie:"Titanic", genre:"Romance"),
            Model(movie:"La la Land", genre:"Romance"),
            Model(movie:"Gone with the Wind", genre:"Romance"),
            Model(movie:"Godfather", genre:"Drama"),
            Model(movie:"Moonlight", genre:"Drama")
        ]

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

    func filterRowsForSearchedText(_ searchText: String) {
        filteredModels = models.filter({( model : Model) -> Bool in
            return model.movie.lowercased().contains(searchText.lowercased())||model.genre.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let term = searchController.searchBar.text {
            filterRowsForSearchedText(term)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        filteredData = []
//
//        let searchPredicate = NSPredicate(format: "SELF CONTAINS[cd] %@", searchController.searchBar.text!)
//        let array = (airportData as NSArray).filteredArrayUsingPredicate(searchPredicate)
//
//        filteredData = array as! [Dictionary<String, String>]
        
        moviesViewModel.getMovies(fromSearch: searchBar.text!) {
            self.tableView.reloadData()
        }
//        self.view.endEditing(true)
        searchController.searchResultsController?.dismiss(animated: true, completion: nil)
        searchController.searchResultsController?.view.isHidden = true
    }

    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        if searchController.isActive && searchController.searchBar.text != "" {
//            return filteredModels.count
//        }
//        return models.count
        return moviesViewModel.numberOfItemsToDisplay(in: section)

    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)

        // Configure the cell...
//        let model: Model
//        if searchController.isActive && searchController.searchBar.text != "" {
//            model = filteredModels[indexPath.row]
//        } else {
//            model = models[indexPath.row]
//        }
//        cell.textLabel!.text = model.movie
//        cell.detailTextLabel!.text = model.genre
        
        
        cell.textLabel?.text = moviesViewModel.movieTitleToDisplay(for: indexPath)
        //8 -
        cell.detailTextLabel?.text = moviesViewModel.movieReleaseDateToDisplay(for: indexPath)
        
//        cell.imageView?.image = //! Image download async
        return cell
    }

}
