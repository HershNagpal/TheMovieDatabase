//
//  BrowseViewController.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/21/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UISearchBarDelegate, NavigationDelegate {

    private let searchBarHeight:CGFloat = 30
    private let collectionHeight:CGFloat = 232
    
    let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    let collectionList:[TVCollection] = [
        {
            let collection = TVCollection(type: CollectionType.UpcomingMovies)
            collection.translatesAutoresizingMaskIntoConstraints = false
            return collection
        }(),
        {
            let collection = TVCollection(type: CollectionType.PopularMovies)
            collection.translatesAutoresizingMaskIntoConstraints = false
            return collection
        }(),
        {
            let collection = TVCollection(type: CollectionType.TopRatedMovies)
            collection.translatesAutoresizingMaskIntoConstraints = false
            return collection
        }(),
        {
            let collection = TVCollection(type: CollectionType.TopRatedShows)
            collection.translatesAutoresizingMaskIntoConstraints = false
            return collection
        }(),
        {
            let collection = TVCollection(type: CollectionType.PopularShows)
            collection.translatesAutoresizingMaskIntoConstraints = false
            return collection
        }(),
        {
            let collection = TVCollection(type: CollectionType.PopularPeople)
            collection.translatesAutoresizingMaskIntoConstraints = false
            return collection
        }(),
        
    ]
    
    let backgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = .black
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
    
    let favoriteButton:UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Favorites"
        return button
    }()
    
    func setUpNavBar() {
        self.navigationController!.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .done, target: self, action: #selector(viewFavorites))
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func loadView() {
        super.loadView()
        setUpNavBar()
        navigationController?.setNavigationBarHidden(false, animated: false )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegates()
        createElementsAndConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = calculateHeight()
    }
    
    func setUpDelegates() {
        searchBar.delegate = self
        for collection in collectionList {
            collection.navDelegate = self
        }
    }
    
    func calculateHeight() -> CGSize {
        let width = Int(view.frame.width)
        let height = Int(collectionHeight)*collectionList.count + Int(searchBarHeight)
        return CGSize(width: width, height: height)
    }
    
    func createElementsAndConstraints() {
        view.addSubview(backgroundView)
        view.addSubview(searchBar)
        view.addSubview(scrollView)
        backgroundViewConstraints()
        searchBarConstraints()
        scrollViewConstraints()
        createCollectionsAndConstraints()
    }
    
    func scrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
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
    
    func createCollectionsAndConstraints() {
        for (index, collection) in collectionList.enumerated() {
            scrollView.addSubview(collection)
            if index == 0 {
                NSLayoutConstraint.activate([
                    collection.topAnchor.constraint(equalTo: scrollView.topAnchor),
                    collection.leftAnchor.constraint(equalTo: view.leftAnchor),
                    collection.rightAnchor.constraint(equalTo: view.rightAnchor),
                    collection.heightAnchor.constraint(equalToConstant: collectionHeight)
                ])
            } else {
                NSLayoutConstraint.activate([
                    collection.topAnchor.constraint(equalTo: collectionList[index-1].bottomAnchor),
                    collection.leftAnchor.constraint(equalTo: view.leftAnchor),
                    collection.rightAnchor.constraint(equalTo: view.rightAnchor),
                    collection.heightAnchor.constraint(equalToConstant: collectionHeight)
                ])
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Request.searchMulti(searchTerms: searchBar.text!) { [weak self] result in
        switch result {
             case .failure(let error):
                 print(error)
             case .success(let items):
                 DispatchQueue.main.async {
                    let vc = SearchViewController()
                    vc.applySearch(searchItems: items)
                    self?.navigationController?.pushViewController(vc, animated: true)
                 }
             }
         }
    }
    
    func cellTapped(_ item: TVItem) {
        navigationController?.pushViewController(DetailViewController(item: item), animated: true)
    }
    
    @objc
    func viewFavorites(sender: UIBarButtonItem) {
        navigationController?.pushViewController(FavoritesViewController(), animated: true)
    }
    
}
