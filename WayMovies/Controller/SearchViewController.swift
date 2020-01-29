//
//  SearchViewController2.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/27/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, NavigationDelegate {
    
    let searchBarHeight:CGFloat = 30
    
    private var searchCollection:SearchCollection = {
        let collection = SearchCollection()
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var searchItems = [TVItem]() {
        didSet {
            searchCollection.applySearch(searchItems: self.searchItems)
        }
    }
    
    init() {
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        createElementsAndConstraints()
        setUpDelegates()
    }
    
    func setUpDelegates() {
        searchBar.delegate = self
        searchCollection.navDelegate = self
    }
    
    func createElementsAndConstraints() {
        view.addSubview(searchBar)
        view.addSubview(searchCollection)
        searchBarConstraints()
        searchCollectionConstraints()
    }
    
    func searchCollectionConstraints() {
        NSLayoutConstraint.activate([
            searchCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchCollection.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchCollection.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func searchBarConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: searchBarHeight)
        ])
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Request.searchMulti(searchTerms: searchBar.text!) { [weak self] result in
        switch result {
             case .failure(let error):
                 print(error)
             case .success(let items):
                self?.searchCollection.applySearch(searchItems: items)
             }
         }
    }
    
    func applySearch(searchItems: [TVItem]) {
        self.searchItems = searchItems
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func cellTapped(_ item: TVItem) {
        navigationController?.pushViewController(DetailViewController(item: item), animated: true)
    }
}
