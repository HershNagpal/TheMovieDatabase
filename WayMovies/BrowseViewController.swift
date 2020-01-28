//
//  BrowseViewController.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/21/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {
    
    let searchBarHeight:CGFloat = 50
    let collectionHeight:CGFloat = 350
    
    let movieRequest = Request()
    var topRatedMoviesCollection:TVCollection = {
        let collection = TVCollection(labelText: "Top Rated Movies")
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
        }()
    
    let backgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = .magenta
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createElementsAndConstraints()
        topRatedMoviesCollection.getTopRatedMovies()
    }
    
    func createElementsAndConstraints() {
        view.addSubview(backgroundView)
        view.addSubview(searchBar)
        view.addSubview(topRatedMoviesCollection)
        
        backgroundViewConstraints()
        searchBarConstraints()
        topRatedMoviesCollectionConstraints()
    }
    
    func backgroundViewConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor)
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
    
    func topRatedMoviesCollectionConstraints() {
        NSLayoutConstraint.activate([
            topRatedMoviesCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            topRatedMoviesCollection.leftAnchor.constraint(equalTo: view.leftAnchor),
            topRatedMoviesCollection.rightAnchor.constraint(equalTo: view.rightAnchor),
            topRatedMoviesCollection.heightAnchor.constraint(equalToConstant: collectionHeight)
        ])
    }
}
