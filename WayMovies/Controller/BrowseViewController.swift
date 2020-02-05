//
//  BrowseViewController.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/21/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {

    // Height of the search bar
    private let searchBarHeight:CGFloat = 40
    
    // Height of each collection in the scroll view
    private let collectionHeight:CGFloat = 250
    
//    var refreshControl = UIRefreshControl()
    
    // The scrolling view of all the collection views on the screen
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    // The table which displays categorized search suggestions
    private let suggestionTable:UITableView = {
        let table = UITableView()
        table.rowHeight = 40
        table.separatorStyle = .singleLine
        table.backgroundColor = .clear
        table.tableFooterView = UIView(frame: CGRect.zero)
        table.isScrollEnabled = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // The list of TVCollections, each which displays a different group of related TVItems
    private let collectionList:[TVCollection] = [
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
    
    // The black background view
    private let backgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // The search bar at the top of the screen under the navigation bar
    private let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // The favorites button in the navigation bar
    private let favoriteButton:UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Favorites"
        return button
    }()
    
    /**
     Sets up the navigation bar at the top of the screen
     */
    private func setUpNavBar() {
        self.navigationController!.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: green]
        self.navigationController!.navigationBar.tintColor = green
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .done, target: self, action: #selector(viewFavorites))
    }
    
    override func loadView() {
        super.loadView()
        setUpNavBar()
        navigationController?.setNavigationBarHidden(false, animated: false )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
//        refreshControl.tintColor = green
//        scrollView.addSubview(refreshControl)
        
        setUpDelegates()
        createElementsAndConstraints()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = calculateHeight()
    }
    
    /**
     Sets up delegates
     */
    private func setUpDelegates() {
        searchBar.delegate = self
        for collection in collectionList {
            collection.navDelegate = self
        }
        suggestionTable.delegate = self
        suggestionTable.dataSource = self
        suggestionTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    /**
     Calculates the heights of of the scrollview necessary to contain all of the collections
     */
    private func calculateHeight() -> CGSize {
        let width = Int(view.frame.width)
        let height = Int(collectionHeight)*collectionList.count + Int(searchBarHeight)
        return CGSize(width: width, height: height)
    }
    
    /**
     Adds all elements to the subview and calls constraining helper methods.
     */
    private func createElementsAndConstraints() {
        view.addSubview(backgroundView)
        view.addSubview(searchBar)
        view.addSubview(scrollView)
        view.addSubview(suggestionTable)
        
        suggestionTable.isHidden = true
        backgroundViewConstraints()
        searchBarConstraints()
        scrollViewConstraints()
        createCollectionsAndConstraints()
        suggestionTableConstraints()
    }
    
    /**
      Sets up constraints for the scroll view
    */
    private func scrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    /**
      Sets up constraints for the background view
    */
    private func backgroundViewConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    /**
      Sets up constraints for the search bar
    */
    private func searchBarConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: searchBarHeight)
        ])
    }
    
    /**
      Sets up constraints for the suggestion table
    */
    private func suggestionTableConstraints() {
        NSLayoutConstraint.activate([
            suggestionTable.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            suggestionTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            suggestionTable.rightAnchor.constraint(equalTo: view.rightAnchor),
            suggestionTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /**
     Creates and constrains the collections in the collection list
     */
    private func createCollectionsAndConstraints() {
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
    
    /**
     Navigates to the favorites page of the item associated with the cell
     */
    @objc func viewFavorites(sender: UIBarButtonItem) {
        navigationController?.pushViewController(FavoritesViewController(), animated: true)
    }
    
//    @objc func refresh() {
//        for collection in collectionList {
//            collection.TVCollection.reloadData()
//        }
//        refreshControl.endRefreshing()
//    }
    
}

extension BrowseViewController: NavigationDelegate {
    /**
     Called when the cell is tapped to navigate to the details page of the item
     */
    func cellTapped(_ item: TVItem) {
        navigationController?.pushViewController(DetailViewController(item: item), animated: true)
    }
}

extension BrowseViewController: UITableViewDelegate, UITableViewDataSource {
    /**
     Returns the number of suggested categorized search options
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    /**
     Returns a tableview cell with a suggested categorized search
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! //1.
        cell.backgroundColor = .white
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "\(searchBar.text ?? "") in Movies"
        case 1:
            cell.textLabel?.text = "\(searchBar.text ?? "") in TV Shows"
        case 2:
            cell.textLabel?.text = "\(searchBar.text ?? "") in People"
        default:
            cell.textLabel?.text = "Enter Search Terms"
        }
        return cell
    }
    
    /**
     Searches TMDB based on the categorized search option selected
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBar.text == "" {
            return
        }
        switch indexPath.row {
        case 0:
            Request.searchMovie(searchTerms: searchBar.text!) { [weak self] result in
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
            searchBar.text = ""
            suggestionTable.isHidden = true
        case 1:
            Request.searchShows(searchTerms: searchBar.text!) { [weak self] result in
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
            searchBar.text = ""
            suggestionTable.isHidden = true
        case 2:
            Request.searchPeople(searchTerms: searchBar.text!) { [weak self] result in
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
            searchBar.text = ""
            suggestionTable.isHidden = true
        default:
            searchBar.text = ""
            suggestionTable.isHidden = true
        }
    }
}

extension BrowseViewController: UISearchBarDelegate {
    /**
     Searches the TMDB when the search button is clicked
     */
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
    
    /**
     Shows the categorized search suggestions when text is being edited and hides when editing stops
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            suggestionTable.reloadData()
            suggestionTable.isHidden = false
        } else {
            suggestionTable.isHidden = true
        }
    }
    
    /**
     Hides the suggestion table when the search cancel button is tapped
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        suggestionTable.isHidden = true
    }
}
