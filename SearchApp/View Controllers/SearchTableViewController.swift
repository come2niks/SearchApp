//
//  SearchTableViewController.swift
//  SearchApp
//
//  Created by Nikhilesh Walde on 23/03/2018.
//  Copyright © 2018 PrepayNation. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    @IBOutlet var searchViewModel: SearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // get search queries and load that in table view
        searchViewModel.getSearchQureies {
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// get number of search queries from view model
        return searchViewModel.numberOfItemsToDisplay()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        /// get search queries string from view model
        cell.textLabel?.text = searchViewModel.queryStringToDisplay(for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// Get movies list from server for selected search string
        (self.presentingViewController as! MoviesTableViewController).getListFromServer(1, fromSearch: searchViewModel.getSelectedSearchString(for: indexPath))
        self.dismiss(animated: true, completion: nil)
    }

}
