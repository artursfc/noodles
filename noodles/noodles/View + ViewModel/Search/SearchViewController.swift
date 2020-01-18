//
//  SearchViewController.swift
//  noodles
//
//  Created by Eloisa Falcão on 15/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResults: UITableView!
    
    let searchSugestions: [String] = ["Canais", "Geral", "Squad"]
    let SEARCHTABLEVIEW = "SearchTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResults.dataSource = self
        searchResults.register(UINib(nibName: SEARCHTABLEVIEW, bundle: nil), forCellReuseIdentifier: SEARCHTABLEVIEW)
        searchResults.separatorColor = UIColor.clear
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchSugestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SEARCHTABLEVIEW) as? SearchTableViewCell ??  SearchTableViewCell()
        cell.searchResult.text = searchSugestions[indexPath.row]
        
        return cell
    }
}

