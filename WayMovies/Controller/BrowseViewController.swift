//
//  BrowseViewController.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/21/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {

    private let searchBarHeight:CGFloat = 40
    private let collectionHeight:CGFloat = 250
    
//    var refreshControl = UIRefreshControl()
    
    let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    let suggestionTable:UITableView = {
        let table = UITableView()
        table.rowHeight = 40
        table.separatorStyle = .singleLine
        table.backgroundColor = .clear
        table.tableFooterView = UIView(frame: CGRect.zero)
        table.isScrollEnabled = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
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
        view.backgroundColor = blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchBar:UISearchBar = {
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
    
    let favoriteButton:UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Favorites"
        return button
    }()
    
    func setUpNavBar() {
        self.navigationController!.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: green]
        self.navigationController!.navigationBar.tintColor = green
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
    
    func setUpDelegates() {
        searchBar.delegate = self
        for collection in collectionList {
            collection.navDelegate = self
        }
        suggestionTable.delegate = self
        suggestionTable.dataSource = self
        suggestionTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        view.addSubview(suggestionTable)
        
        suggestionTable.isHidden = true
        backgroundViewConstraints()
        searchBarConstraints()
        scrollViewConstraints()
        createCollectionsAndConstraints()
        suggestionTableConstraints()
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
    
    func suggestionTableConstraints() {
        
        NSLayoutConstraint.activate([
            suggestionTable.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            suggestionTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            suggestionTable.rightAnchor.constraint(equalTo: view.rightAnchor),
            suggestionTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
    func cellTapped(_ item: TVItem) {
        navigationController?.pushViewController(DetailViewController(item: item), animated: true)
    }
}

extension BrowseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            suggestionTable.reloadData()
            suggestionTable.isHidden = false
        } else {
            suggestionTable.isHidden = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        suggestionTable.isHidden = true
    }
}
