//
//  SearchViewController2.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/27/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    let searchBarHeight:CGFloat = 40
    
    private var searchCollection:SearchCollection = {
        let collection = SearchCollection()
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    let suggestionTable:UITableView = {
        let table = UITableView()
        table.rowHeight = 40
        table.separatorStyle = .singleLine
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableFooterView = UIView(frame: CGRect.zero)
        table.isScrollEnabled = false
        table.backgroundColor = .clear
        return table
    }()
    
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
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var searchItems = [TVItem]()
    
    func setUpNavBar() {
        self.navigationController!.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: green]
        self.navigationController!.navigationBar.tintColor = translucent_green
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .done, target: self, action: #selector(viewFavorites))
    }
    
    init() {
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        setUpNavBar()
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createElementsAndConstraints()
        setUpDelegates()
    }
    
    func setUpDelegates() {
        searchBar.delegate = self
        searchCollection.navDelegate = self
        suggestionTable.delegate = self
        suggestionTable.dataSource = self
        suggestionTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func createElementsAndConstraints() {
        view.addSubview(backgroundView)
        view.addSubview(searchBar)
        view.addSubview(searchCollection)
        view.addSubview(suggestionTable)
        suggestionTable.isHidden = true
        backgroundViewConstraints()
        searchBarConstraints()
        searchCollectionConstraints()
        suggestionTableConstraints()
    }
    
    func searchCollectionConstraints() {
        NSLayoutConstraint.activate([
            searchCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchCollection.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchCollection.rightAnchor.constraint(equalTo: view.rightAnchor)
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
    
    func applySearch(searchItems: [TVItem]) {
        self.searchItems = searchItems
        searchCollection.applySearch(searchItems: searchItems)
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc func viewFavorites(sender: UIBarButtonItem) {
        navigationController?.pushViewController(FavoritesViewController(), animated: true)
    }
}

extension SearchViewController: NavigationDelegate {
    func cellTapped(_ item: TVItem) {
        navigationController?.pushViewController(DetailViewController(item: item), animated: true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
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
                    self?.searchCollection.applySearch(searchItems: items)
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
                    self?.searchCollection.applySearch(searchItems: items)
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
                    self?.searchCollection.applySearch(searchItems: items)
                 }
             }
            searchBar.text = ""
            suggestionTable.isHidden = true
        default:
            searchBar.text = ""
            suggestionTable.isHidden = true
        }
    }
    
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
}

extension SearchViewController: UISearchBarDelegate {
        
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Request.searchMulti(searchTerms: searchBar.text!) { [weak self] result in
        switch result {
             case .failure(let error):
                 print(error)
             case .success(let items):
                self?.searchCollection.applySearch(searchItems: items)
             }
         }
        searchBar.text = ""
    }
}
