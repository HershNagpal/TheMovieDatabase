//
//  SearchViewController.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/21/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import UIKit


class SearchViewControllerOld: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let searchCellID:String = "cellID"
    var searchItems = [TVItem]()
    let movieRequest = Request()
    
    let searchCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x:0, y:0, width:0, height:0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collection.backgroundColor = UIColor.gray
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        return collection
    }()
    
    let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let backButton:UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollection.register(MovieShowCell.self, forCellWithReuseIdentifier: searchCellID)
        searchBar.delegate = self
        searchCollection.delegate = self
        searchCollection.dataSource = self
        createElementsAndConstraints()
    }
    
    func createElementsAndConstraints() {
        view.addSubview(searchBar)
        view.addSubview(backButton)
        view.addSubview(searchCollection)
        searchBarConstraints()
        backButtonConstraints()
        searchCollectionConstraints()
    }
    
    func searchBarConstraints() {
        let height:CGFloat = 30
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
//            searchBar.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: 50),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func backButtonConstraints() {
        let height:CGFloat = 30
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
//            backButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            backButton.rightAnchor.constraint(equalTo: searchBar.leftAnchor),
            backButton.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func searchCollectionConstraints() {
        NSLayoutConstraint.activate([
            searchCollection.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchCollection.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCellID, for: indexPath) as! MovieShowCell
        let item = searchItems[indexPath.row]
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 5
        
        if(item.title != nil) {
            //Case Movie
            cell.titleLabel.text = item.title
            cell.ratingLabel.text = "Average User Rating: 0p0po\(String(item.vote_average!))"
            
        } else if(item.known_for_department != nil) {
            //Case Actor
            cell.titleLabel.text = item.name
            
        } else {
            //Case Show
            cell.titleLabel.text = item.name
            cell.ratingLabel.text = "Average User Rating: \(String(item.vote_average!))"
            
        }
        
        guard let path = item.poster_path else {
            let def = UIImage(named: "default")
            cell.imageView.image = def
            return cell
        }
                
        getImage(searchTerms: path) { (result) in
            switch result {
                case .failure(let error):
                   print(error)
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: data)
                    }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
//        print("yeet ")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        movieRequest.searchMulti(searchTerms: searchBar.text!) { [weak self] result in
        switch result {
             case .failure(let error):
                 print(error)
             case .success(let items):
                 self?.searchItems = items
                 DispatchQueue.main.async {
                     self?.searchCollection.reloadData()
                 }
             }
             
         }
    }
    
    func getImage(searchTerms: String, completion: @escaping(Result<Data, Error>) -> Void) {
        movieRequest.getImage(searchTerms: searchTerms) { [weak self] result in
        completion(result)
        }
    }
    
}
