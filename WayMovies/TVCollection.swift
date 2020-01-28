//
//  TopRatedMoviesCollection.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/24/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit

class TopRatedMoviesCollection: UICollectionViewFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    var topRatedMovies = [TVItem]()
    let topRatedMovieCellID:String = "CellID"
    let movieRequest = Request()
    
    let labelHeight:CGFloat = 30
    let collectionHeight:CGFloat = 210
    let cellHeight:CGFloat = 200
    let cellWidth:CGFloat = 140
    let searchBarHeight:CGFloat = 50
    let cellInsetSize:CGFloat = 3
    
    let topRatedMoviesCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x:0, y:0, width:0, height:0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = .magenta
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        return collection
    }()
    
    let topRatedMoviesLabel:UILabel = {
        let label = UILabel()
        label.text = "Top Rated Movies"
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init() {
        super.init()
        registerCollectionCellsAndDelegates()
    }
    
    func registerCollectionCellsAndDelegates() {
        topRatedMoviesCollection.delegate = self
        topRatedMoviesCollection.dataSource = self
        topRatedMoviesCollection.register(MovieShowCell.self, forCellWithReuseIdentifier: topRatedMovieCellID)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topRatedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellInsetSize, left: cellInsetSize, bottom: cellInsetSize, right: cellInsetSize)
    }
    
    func getTopRatedMovies() {
        movieRequest.getTopRatedMovies { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let items):
                self?.topRatedMovies = items
                DispatchQueue.main.async {
                    self?.topRatedMoviesCollection.reloadData()
                }
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getImage(searchTerms: String, completion: @escaping(Result<Data, Error>) -> Void) {
        movieRequest.getImage(searchTerms: searchTerms) { [weak self] result in
        completion(result)
        }
    }
    
}
