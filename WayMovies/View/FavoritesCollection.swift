//
//  FavoritesCollection.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/29/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit

var favoritesMap = [Int:TVItem]()

class FavoritesCollection: UIView, UICollectionViewDelegateFlowLayout {
        
    // Delegate which manages navigation to the details page of each cell
    var navDelegate:NavigationDelegate?
    
    // Cell reuse ID
    private let searchCellID:String = "CellID"
    
    // The height of each cell in the collection
    private let cellHeight:CGFloat = 300
    
    // The width of each cell in the collection
    private let cellWidth:CGFloat = 200
    
    // The size of the insets around each cell
    private let cellInsetSize:CGFloat = 1
    
    // The collection that displays the user's favorite movies
    let favoritesCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x:0, y:0, width:0, height:0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collection.backgroundColor = blue
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        return collection
    }()
    
    init() {
//        self.searchItems = [TVItem]()
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        registerCollectionCellsAndDelegates()
        createElementsAndConstraints()
    }
    
    /**
     Adds all elements to the subview and calls constraining helper methods.
     */
    private func createElementsAndConstraints() {
        addSubview(favoritesCollection)
        favoritesCollectionConstraints()
    }
    
    /**
     Sets delegates and registers cell reuse ID's
     */
    private func registerCollectionCellsAndDelegates() {
        favoritesCollection.delegate = self
        favoritesCollection.dataSource = self
        favoritesCollection.register(TVCell.self, forCellWithReuseIdentifier: searchCellID)
    }
    
    /**
     Sets up constraints for the FavoritesCollection
     */
    private func favoritesCollectionConstraints() {
        NSLayoutConstraint.activate([
            favoritesCollection.topAnchor.constraint(equalTo: self.topAnchor),
            favoritesCollection.leftAnchor.constraint(equalTo: self.leftAnchor),
            favoritesCollection.rightAnchor.constraint(equalTo: self.rightAnchor),
            favoritesCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    /**
     Removes the given TVItem from the list of the user's favorites
     `Parameter item: The TVItem to remove from favorites`
     */
    static func removeFromFavorites(item:TVItem) {
        favoritesMap.removeValue(forKey: item.id)
    }
    
    static func isInFavorites(item:TVItem) -> Bool {
        if favoritesMap[item.id] != nil{
            return true
        }
        return false
    }
    
    /**
     Adds a TVItem to the list of favorites
     `Parameter item: The TVItem to add to favorites`
     */
    static func addToFavorites(item:TVItem) {
        favoritesMap[item.id] = item
    }
    
    /**
     Calls the API retrieval of the poster image of a TVItem in the Request class and returns the image location when escaping
     `Parameter searchTerms: The search string given by the user`
     */
    private func getImage(searchTerms: String, completion: @escaping(Result<Data, Error>) -> Void) {
            Request.getImage(searchTerms: searchTerms) { result in
            completion(result)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Applies the image retrieved using the getImage method to the cell
     `Parameter: cell: the cell to apply the image to`
     `Parameter: item: the item which holds the information needed to retreive the image`
     */
    private func getCellImage (cell: TVCell, item: TVItem) {
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
    
    /**
     Sets all attributes of the cells in the collection to their defaults
     `Parameter cell: the cell to set defaults`
     `Parameter item: the cell which holds the information to set in the cell`
     */
    private func setCellDefaults(cell: TVCell, item: TVItem) {
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
}

extension FavoritesCollection: UICollectionViewDataSource, UICollectionViewDelegate {
    
    /**
     Returns the total number of cells in the collection
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesMap.count
    }
    
    /**
     Returns a cell with the information of a specifc index of the list of TVItems to display in this collection
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCellID, for: indexPath) as! TVCell
        let item = Array(favoritesMap.values)[indexPath.row]
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
        let item:TVItem = Array(favoritesMap.values)[indexPath.row]
        navDelegate?.cellTapped(item)
    }

}
