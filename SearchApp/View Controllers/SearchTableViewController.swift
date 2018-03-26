//
//  SearchTableViewController.swift
//  SearchApp
//
//  Created by Nikhilesh Walde on 23/03/2018.
//  Copyright © 2018 PrepayNation. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

//    var searchQueries: [String] = []
    
    @IBOutlet var searchViewModel: SearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchViewModel.getSearchQureies {
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchViewModel.numberOfItemsToDisplay(in: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = searchViewModel.queryStringToDisplay(for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (self.presentingViewController as! MoviesTableViewController).getListFromServer(1, fromSearch: searchViewModel.searchStringSelected(for: indexPath))
        self.dismiss(animated: true, completion: nil)
    }

}
