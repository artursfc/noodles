//
//  SearchViewController.swift
//  noodles
//
//  Created by Eloisa Falcão on 15/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchResults: UITableView!
    
    var objects: [Objects] = []
    let searchController = UISearchController(searchResultsController: nil)
    var filteredObjects: [Objects] = []
    let searchSugestions: [String] = ["Canais", "Geral", "Squad"]
    let SEARCHTABLEVIEW = "SearchTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResults.dataSource = self
        searchResults.register(UINib(nibName: SEARCHTABLEVIEW, bundle: nil), forCellReuseIdentifier: SEARCHTABLEVIEW)
        searchResults.separatorColor = UIColor.clear
        setupSearchBar()
        self.navigationController?.isNavigationBarHidden = true
//        addObserver()
    }
    
    func setupSearchBar() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.isHidden = false
        searchController.searchBar.scopeButtonTitles = Objects.Category.allCases.map { $0.rawValue }
                
    }
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String,
                                    category: Objects.Category? = nil) {
      filteredObjects = objects.filter { (object: Objects) -> Bool in
        let doesCategoryMatch = category == .undefined || object.category == category
        
        if isSearchBarEmpty {
          return doesCategoryMatch
        } else {
          return doesCategoryMatch && object.name.lowercased().contains(searchText.lowercased())
        }
      }
      
      searchResults.reloadData()
    }
 
//    func addObserver() {
//        
//        let notificationCenter = NotificationCenter.default
//           notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
//                                          object: nil, queue: .main) { (notification) in
//                                           self.handleKeyboard(notification: notification) }
//           notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
//                                          object: nil, queue: .main) { (notification) in
//                                           self.handleKeyboard(notification: notification) }
//    }
    
//    func handleKeyboard(notification: Notification) {
//      // 1
//      guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
//        view.layoutIfNeeded()
//        return
//      }
//      
//      guard
//        let info = notification.userInfo,
//        let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
//        else {
//          return
//      }
//      
//      // 2
//      let keyboardHeight = keyboardFrame.cgRectValue.size.height
//      UIView.animate(withDuration: 0.1, animations: { () -> Void in
//        self.view.layoutIfNeeded()
//      })
//    }
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

extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

