//
//  SearchCollection.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/27/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit



class SearchCollection: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var searchItems = [TVItem]() {
        didSet {
            DispatchQueue.main.async {
                self.searchCollection.reloadData()
            }
        }
    }
    let searchCellID:String = "CellID"
    let movieRequest = Request()
    let cellHeight:CGFloat = 300
    let cellWidth:CGFloat = 200
    let cellInsetSize:CGFloat = 1
    
    let searchCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x:0, y:0, width:0, height:0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collection.backgroundColor = UIColor.gray
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
        searchCollection.register(MovieShowCell.self, forCellWithReuseIdentifier: searchCellID)
    }
    
    func searchCollectionConstraints() {
        NSLayoutConstraint.activate([
            searchCollection.topAnchor.constraint(equalTo: self.topAnchor),
            searchCollection.leftAnchor.constraint(equalTo: self.leftAnchor),
            searchCollection.rightAnchor.constraint(equalTo: self.rightAnchor),
            searchCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor)
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
            cell.typeLabel.text = "Movie"
            cell.titleLabel.text = item.title
            cell.ratingLabel.text = "Average User Rating: \(String(item.vote_average!))"
            
        } else if(item.known_for_department != nil) {
            //Case Actor
            cell.typeLabel.text = "Person"
            cell.titleLabel.text = item.name
            
        } else {
            //Case Show
            cell.typeLabel.text = "Show"
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
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellInsetSize, left: cellInsetSize, bottom: cellInsetSize, right: cellInsetSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detailVC = DetailViewController()
//        navigationController.push()
    }
    
    func getImage(searchTerms: String, completion: @escaping(Result<Data, Error>) -> Void) {
        movieRequest.getImage(searchTerms: searchTerms) { result in
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
