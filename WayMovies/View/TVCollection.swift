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

    private let type:CollectionType
    private let labelHeight:CGFloat = 30
    private let collectionHeight:CGFloat = 202
    private let cellHeight:CGFloat = 200
    private let cellWidth:CGFloat = 145
    private let cellInsetSize:CGFloat = 1
    
    var navDelegate:NavigationDelegate?
    
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
        case CollectionType.PopularMovies:
            self.TVCollectionLabel.text = "Popular Movies"
            self.getPopularMovies()
        case CollectionType.UpcomingMovies:
            self.TVCollectionLabel.text = "Upcoming Movies"
            self.getUpcomingMovies()
        case CollectionType.TopRatedShows:
            self.TVCollectionLabel.text = "Top Rated TV Shows"
            self.getTopRatedShows()
        case CollectionType.PopularShows:
            self.TVCollectionLabel.text = "Popular TV Shows"
            self.getPopularShows()
        case CollectionType.PopularPeople:
            self.TVCollectionLabel.text = "Popular People"
            self.getPopularPeople()
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
        cell.titleLabel.text = item.title ?? item.name ?? "Untitled Movie Lol"
        cell.setItem(item: item)
        
        if(item.title != nil) {
            //Case Movie
//            cell.typeLabel.text = "Movie"
            cell.titleLabel.text = item.title
            cell.ratingLabel.text = "Average Rating: \(String(item.vote_average!))"
            cell.imageView.image = UIImage(named: "movie_default.jpg")
            
        } else if(item.known_for_department != nil) {
            //Case Actor
//            cell.typeLabel.text = "Person"
            cell.titleLabel.text = item.name
            cell.imageView.image = UIImage(named: "profile_default.jpg")
        } else {
            //Case Show
//            cell.typeLabel.text = "Show"
            cell.titleLabel.text = item.name
            cell.ratingLabel.text = "Average Rating: \(String(item.vote_average!))"
            cell.imageView.image = UIImage(named: "movie_default.jpg")
            
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
                            cell.ratingLabel.text = ""
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item:TVItem = TVList[indexPath.row]
        navDelegate?.cellTapped(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellInsetSize, left: cellInsetSize, bottom: cellInsetSize, right: cellInsetSize)
    }
    
    func getTopRatedMovies() {
        Request.getTopRatedMovies { [weak self] result in
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
        Request.getPopularMovies { [weak self] result in
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
    
    func getPopularShows() {
        Request.getPopularShows { [weak self] result in
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
    
    func getPopularPeople() {
        Request.getPopularPeople { [weak self] result in
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
    
    func getTopRatedShows() {
        Request.getTopRatedShows { [weak self] result in
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
        Request.getUpcomingMovies { [weak self] result in
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
        Request.getImage(searchTerms: searchTerms) { result in
        completion(result)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
