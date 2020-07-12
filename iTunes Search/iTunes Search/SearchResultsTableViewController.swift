//
//  SearchResultsTableViewController.swift
//  iTunes Search
//
//  Created by Eoin Lavery on 12/07/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    @IBOutlet weak var searchTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let searchResultsContoller = SearchResultController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsContoller.searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)

        let searchResult = searchResultsContoller.searchResults[indexPath.row]
        
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.creator
        
        return cell
    }

}

extension SearchResultsTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text else {
            print("No search term entered.")
            return
        }
        
        let searchTypeIndex = searchTypeSegmentedControl.selectedSegmentIndex
        
        var searchType: ResultType
        
        switch searchTypeIndex {
        case 0:
            searchType = .software
        case 1:
            searchType = .musicTrack
        case 2:
            searchType = .movie
        default:
            searchType = .software
        }
        
        searchResultsContoller.performSearch(searchTerm: text, resultType: searchType) { (error) in
            
            guard error == nil else {
                print("Error returned from SearchResultsController")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.resignFirstResponder()
            }
            
        }
    }
    
}
