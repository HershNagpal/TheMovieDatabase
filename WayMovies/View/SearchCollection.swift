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
    
    // List of items retrieved from API call
    private var searchItems = [TVItem]() {
        didSet {
            DispatchQueue.main.async {
                self.searchCollection.reloadData()
            }
        }
    }
    
    // Delegate that manages navigation to the details page of each cell
    var navDelegate:NavigationDelegate?
    
    // Cell reuse ID
    private let searchCellID:String = "CellID"
    
    // The height of each cell in the collection
    private let cellHeight:CGFloat = 300
    
    // The width of each cell in the collection
    private let cellWidth:CGFloat = 200
    
    // The size of the margins around each cell
    private let cellInsetSize:CGFloat = 1
    
    // The CollectionView that shows all of the results of the search
    let searchCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x:0, y:0, width:0, height:0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collection.backgroundColor = blue
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
    
    /**
     Adds all elements to the subview and calls constraining helper methods.
     */
    private func createElementsAndConstraints() {
        addSubview(searchCollection)
        searchCollectionConstraints()
    }
    
    /**
     Sets delegates and registers cell reuse ID's
     */
    private func registerCollectionCellsAndDelegates() {
        searchCollection.delegate = self
        searchCollection.dataSource = self
        searchCollection.register(TVCell.self, forCellWithReuseIdentifier: searchCellID)
    }
    
    /**
     Sets up constraints for the SearchCollection
     */
    private func searchCollectionConstraints() {
        NSLayoutConstraint.activate([
            searchCollection.topAnchor.constraint(equalTo: self.topAnchor),
            searchCollection.leftAnchor.constraint(equalTo: self.leftAnchor),
            searchCollection.rightAnchor.constraint(equalTo: self.rightAnchor),
            searchCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    /**
     Calls a Request to the API with the search terms given by the user
     */
    private func getImage(searchTerms: String, completion: @escaping(Result<Data, Error>) -> Void) {
            Request.getImage(searchTerms: searchTerms) { result in
            completion(result)
        }
    }
    
    /**
     Applies the results of a search to this collection
     `Parameter searchItems: the list of TVItems retrieved from the API search`
     */
    func applySearch(searchItems:[TVItem]) {
        self.searchItems = searchItems
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Sets all attributes of the cells in the collection to their defaults
     */
    private func setCellDefaults(cell: TVCell, item: TVItem) {
        cell.setItem(item: item)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 5
        
        if(item.title != nil) {
            //Case Movie
            cell.typeLabel.text = "Movie"
            cell.titleLabel.text = item.title
            if item.vote_average != nil {
                cell.ratingView.widthAnchor.constraint(equalToConstant: cell.ratingView.calculateWidth(item: item)).isActive = true
            }
            
        } else if(item.known_for_department != nil) {
            //Case Actor
            cell.typeLabel.text = "Person"
            cell.titleLabel.text = item.name
            
        } else {
            //Case Show
            cell.typeLabel.text = "Show"
            cell.titleLabel.text = item.name
            if item.vote_average != nil {
                cell.ratingView.widthAnchor.constraint(equalToConstant: cell.ratingView.calculateWidth(item: item)).isActive = true
            }
        }
    }
    
    /**
     Applies the image retrieved using the getImage method to the cell
     */
    private func getCellImage(cell: TVCell, item: TVItem) {
        let tag = cell.tag
        if let path = item.poster_path, !path.isEmpty {
            getImage(searchTerms: path) { (result) in
                switch result {
                    case .failure(let error):
                       print(error)
                    case .success(let data):
                        DispatchQueue.main.async {
                            if tag == cell.tag {
                                cell.imageView.image = UIImage(data: data)
                                cell.titleLabel.text = ""
                        }
                    }
                }
            }
        } else if let path = item.profile_path, !path.isEmpty  {
            let tag = cell.tag
            getImage(searchTerms: path) { (result) in
                switch result {
                    case .failure(let error):
                       print(error)
                    case .success(let data):
                        DispatchQueue.main.async {
                            if tag == cell.tag {
                                cell.imageView.image = UIImage(data: data)
//                                cell.titleLabel.text = ""
                        }
                    }
                }
            }
        }
    }
}

extension SearchCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    /**
     Returns the total number of cells
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchItems.count
    }
    
    /**
     Returns a cell with the information of a specifc index of the list of TVItems to display in this collection
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCellID, for: indexPath) as! TVCell
        let item = searchItems[indexPath.row]
        cell.tag = indexPath.row
        setCellDefaults(cell: cell, item: item)
        getCellImage(cell: cell, item: item)
        return cell
    }
    
    /**
     Returns the dimensions of the cell
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    /**
     Returns the size of the insets around each cell
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellInsetSize, left: cellInsetSize, bottom: cellInsetSize, right: cellInsetSize)
    }
    
    /**
     Navigates to the details page of the TVItem represented by this cell when it is tapped
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item:TVItem = searchItems[indexPath.row]
        navDelegate?.cellTapped(item)
    }

}
