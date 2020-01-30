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

class FavoritesCollection: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
    var navDelegate:NavigationDelegate?
    
    let searchCellID:String = "CellID"
    let cellHeight:CGFloat = 300
    let cellWidth:CGFloat = 200
    let cellInsetSize:CGFloat = 1
    
    let favoritesCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x:0, y:0, width:0, height:0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collection.backgroundColor = .black
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
    
    func createElementsAndConstraints() {
        addSubview(favoritesCollection)
        favoritesCollectionConstraints()
    }
    
    func registerCollectionCellsAndDelegates() {
        favoritesCollection.delegate = self
        favoritesCollection.dataSource = self
        favoritesCollection.register(TVCell.self, forCellWithReuseIdentifier: searchCellID)
    }
    
    func favoritesCollectionConstraints() {
        NSLayoutConstraint.activate([
            favoritesCollection.topAnchor.constraint(equalTo: self.topAnchor),
            favoritesCollection.leftAnchor.constraint(equalTo: self.leftAnchor),
            favoritesCollection.rightAnchor.constraint(equalTo: self.rightAnchor),
            favoritesCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    static func removeFromFavorites(item:TVItem) {
        favoritesMap.removeValue(forKey: item.id)
    }
    
    static func isInFavorites(item:TVItem) -> Bool {
        if favoritesMap[item.id] != nil{
            return true
        }
        return false
    }
    
    static func addToFavorites(item:TVItem) {
        favoritesMap[item.id] = item
        print(favoritesMap)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesMap.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCellID, for: indexPath) as! TVCell

        let item = Array(favoritesMap.values)[indexPath.row]
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 5
        cell.setItem(item: item)
        
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
        } else {
            return cell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellInsetSize, left: cellInsetSize, bottom: cellInsetSize, right: cellInsetSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item:TVItem = Array(favoritesMap.values)[indexPath.row]
        navDelegate?.cellTapped(item)
    }
    
    func getImage(searchTerms: String, completion: @escaping(Result<Data, Error>) -> Void) {
            Request.getImage(searchTerms: searchTerms) { result in
            completion(result)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
