//
//  SearchCollection.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/27/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit

class SearchCollection: UIView, UICollectionViewDelegateFlowLayout {
    
    
    private var searchItems = [TVItem]() {
        didSet {
            DispatchQueue.main.async {
                self.searchCollection.reloadData()
            }
        }
    }
    
    var navDelegate:NavigationDelegate?
    
    let searchCellID:String = "CellID"
    let cellHeight:CGFloat = 300
    let cellWidth:CGFloat = 200
    let cellInsetSize:CGFloat = 1
    
    let searchCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x:0, y:0, width:0, height:0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collection.backgroundColor = .black
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        return collection
    }()
    
    init(searchItems:[TVItem]) {
        self.searchItems = searchItems
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        registerCollectionCellsAndDelegates()
        createElementsAndConstraints()
    }
    
    init() {
        self.searchItems = [TVItem]()
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        registerCollectionCellsAndDelegates()
        createElementsAndConstraints()
    }
    
    func createElementsAndConstraints() {
        addSubview(searchCollection)
        searchCollectionConstraints()
    }
    
    func registerCollectionCellsAndDelegates() {
        searchCollection.delegate = self
        searchCollection.dataSource = self
        searchCollection.register(TVCell.self, forCellWithReuseIdentifier: searchCellID)
    }
    
    func searchCollectionConstraints() {
        NSLayoutConstraint.activate([
            searchCollection.topAnchor.constraint(equalTo: self.topAnchor),
            searchCollection.leftAnchor.constraint(equalTo: self.leftAnchor),
            searchCollection.rightAnchor.constraint(equalTo: self.rightAnchor),
            searchCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func getImage(searchTerms: String, completion: @escaping(Result<Data, Error>) -> Void) {
            Request.getImage(searchTerms: searchTerms) { result in
            completion(result)
        }
    }
    
    
    func applySearch(searchItems:[TVItem]) {
        self.searchItems = searchItems
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCellID, for: indexPath) as! TVCell
        let item = searchItems[indexPath.row]
        setCellDefaults(cell: cell, item: item)
        getCellImage(cell: cell, item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellInsetSize, left: cellInsetSize, bottom: cellInsetSize, right: cellInsetSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item:TVItem = searchItems[indexPath.row]
        navDelegate?.cellTapped(item)
    }
    
    func setCellDefaults(cell: TVCell, item: TVItem) {
        cell.setItem(item: item)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 5
        
        if(item.title != nil) {
            //Case Movie
            cell.typeLabel.text = "Movie"
            cell.titleLabel.text = item.title
            cell.ratingLabel.text = "Average Rating: \(String(item.vote_average!))"
            
        } else if(item.known_for_department != nil) {
            //Case Actor
            cell.typeLabel.text = "Person"
            cell.titleLabel.text = item.name
            
        } else {
            //Case Show
            cell.typeLabel.text = "Show"
            cell.titleLabel.text = item.name
            cell.ratingLabel.text = "Average Rating: \(String(item.vote_average!))"
            
        }
    }
    
    func getCellImage (cell: TVCell, item: TVItem) {
            if item.poster_path != "" && item.poster_path != nil {
                getImage(searchTerms: item.poster_path!) { (result) in
                    switch result {
                        case .failure(let error):
                           print(error)
                        case .success(let data):
                            DispatchQueue.main.async {
                                cell.imageView.image = UIImage(data: data)
                                cell.titleLabel.text = ""
                        }
                    }
                }
            } else if item.profile_path != "" && item.profile_path != nil {
                getImage(searchTerms: item.profile_path!) { (result) in
                    switch result {
                        case .failure(let error):
                           print(error)
                        case .success(let data):
                            DispatchQueue.main.async {
                                cell.imageView.image = UIImage(data: data)
    //                            cell.titleLabel.text = ""
                        }
                    }
                }
            }
        }
}
