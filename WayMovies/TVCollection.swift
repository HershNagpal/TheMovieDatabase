//
//  TVCollection.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/24/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit

class TVCollection: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var TVList = [TVItem]()
    private let TVCellID:String = "CellID"
    
    private let movieRequest = Request()
    private let type:CollectionType
    private let labelHeight:CGFloat = 30
    private let collectionHeight:CGFloat = 202
    private let cellHeight:CGFloat = 200
    private let cellWidth:CGFloat = 145
    private let cellInsetSize:CGFloat = 1
    
    let TVCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x:0, y:0, width:0, height:0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = .black
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        return collection
    }()
    
    let TVCollectionLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        self.type = CollectionType.TopRatedMovies
        super.init(frame: frame)
        registerCollectionCellsAndDelegates()
        createElementsAndConstraints()
        self.setTypeMethods()
    }
    
    init(type: CollectionType) {
        self.type = type
        super.init(frame: CGRect(x:0, y:0, width:0, height:0))
        registerCollectionCellsAndDelegates()
        createElementsAndConstraints()
        self.setTypeMethods()
    }
    
    func setTypeMethods() {
        switch self.type {
        case CollectionType.TopRatedMovies:
            self.TVCollectionLabel.text = "Top Rated Movies"
            self.getTopRatedMovies()
        case CollectionType.TrendingMovies:
            self.TVCollectionLabel.text = "Popular Movies"
            self.getPopularMovies()
        case CollectionType.UpcomingMovies:
            self.TVCollectionLabel.text = "Upcoming Movies"
            self.getUpcomingMovies()
        default:
            self.TVCollectionLabel.text = "Top Rated Movies"
            self.getTopRatedMovies()
        }
    }
    
    func createElementsAndConstraints() {
        addSubview(TVCollectionLabel)
        addSubview(TVCollection)
        TVCollectionLabelConstraints()
        TVCollectionConstraints()
    }
    
    func registerCollectionCellsAndDelegates() {
        TVCollection.delegate = self
        TVCollection.dataSource = self
        TVCollection.register(TVCell.self, forCellWithReuseIdentifier: TVCellID)
    }
    
    func TVCollectionLabelConstraints() {
        NSLayoutConstraint.activate([
            TVCollectionLabel.topAnchor.constraint(equalTo: self.topAnchor),
            TVCollectionLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            TVCollectionLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            TVCollectionLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
    }
    
    func TVCollectionConstraints() {
        NSLayoutConstraint.activate([
            TVCollection.topAnchor.constraint(equalTo: TVCollectionLabel.bottomAnchor),
            TVCollection.leftAnchor.constraint(equalTo: self.leftAnchor),
            TVCollection.rightAnchor.constraint(equalTo: self.rightAnchor),
            TVCollection.heightAnchor.constraint(equalToConstant: collectionHeight)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TVList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = TVCollection.dequeueReusableCell(withReuseIdentifier: TVCellID, for: indexPath) as! TVCell
        
        let item = TVList[indexPath.row]
        cell.backgroundColor = .white
        cell.titleLabel.text = item.title ?? "Untitled Movie Lol"
        
        guard let path = item.poster_path else {
//            let def = UIImage(named: "default")
//            cell.imageView.image = def
            return cell
        }
                
        getImage(searchTerms: path) { (result) in
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detailVC = DetailViewController()
//        navigationController?.pushViewController(detailVC, animated: true)
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
                self?.TVList = items
                DispatchQueue.main.async {
                    self?.TVCollection.reloadData()
                }
            }
        }
    }
    
    func getPopularMovies() {
        movieRequest.getPopularMovies { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let items):
                self?.TVList = items
                DispatchQueue.main.async {
                    self?.TVCollection.reloadData()
                }
            }
        }
    }
    
    func getUpcomingMovies() {
        movieRequest.getUpcomingMovies { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let items):
                self?.TVList = items
                DispatchQueue.main.async {
                    self?.TVCollection.reloadData()
                }
            }
        }
    }
    
    func getImage(searchTerms: String, completion: @escaping(Result<Data, Error>) -> Void) {
        movieRequest.getImage(searchTerms: searchTerms) { result in
        completion(result)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
