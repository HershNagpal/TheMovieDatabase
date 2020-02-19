//
//  TVCollection.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/24/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit

/**
 Shows the TVItems from various calls such as Top Movies, Popular Shows, etc.
 */
class TVCollection: UIView, UICollectionViewDelegateFlowLayout {
    
    // The list of TVItems retrieved from the specified group
    private var TVList = [TVItem]()
    
    // Cell reuse ID
    private let TVCellID:String = "CellID"
    
    // The group of TVItems to show (Top Rated Movies, Popular Shows, Etc.)
    private let type:CollectionType
    
    // The height of the Label above the collection
    private let labelHeight:CGFloat = 40
    
    // The height of the collection
    private let collectionHeight:CGFloat = 202
    
    // The height of each cell in the collection
    private let cellHeight:CGFloat = 200
    
    // The width of each cell in the collection
    private let cellWidth:CGFloat = 145
    
    // The size of the insets around each cell in the collection
    private let cellInsetSize:CGFloat = 1
    
    // The NavigationDelegate which allows
    var navDelegate:NavigationDelegate?
    
    //The CollectionView that shows all of the TVItems in the TVList
    let TVCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x:0, y:0, width:0, height:0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = Colors.blue
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        return collection
    }()
    
    // Shows the group of movies being displayed by the collection
    let TVCollectionLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = Colors.translucentGreen
        label.font = label.font.withSize(25)
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
    
    /**
     Gets the list of TVItems associated with the given CollectionType
     */
    private func setTypeMethods() {
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
    
    /**
     Adds all elementts to the subview and calls constraining helper methods.
     */
    private func createElementsAndConstraints() {
        addSubview(TVCollectionLabel)
        addSubview(TVCollection)
        TVCollectionLabelConstraints()
        TVCollectionConstraints()
    }
    
    /**
     Sets delegates and registers cell reuse ID's
     */
    private func registerCollectionCellsAndDelegates() {
        TVCollection.delegate = self
        TVCollection.dataSource = self
        TVCollection.register(TVCell.self, forCellWithReuseIdentifier: TVCellID)
    }
    
    /**
     Sets up constraints for the TVCollection label
     */
    private func TVCollectionLabelConstraints() {
        NSLayoutConstraint.activate([
            TVCollectionLabel.topAnchor.constraint(equalTo: self.topAnchor),
            TVCollectionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3),
            TVCollectionLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            TVCollectionLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
    }
    
    /**
     Sets up constraints for the TVCollection
     */
    private func TVCollectionConstraints() {
        NSLayoutConstraint.activate([
            TVCollection.topAnchor.constraint(equalTo: TVCollectionLabel.bottomAnchor),
            TVCollection.leftAnchor.constraint(equalTo: self.leftAnchor),
            TVCollection.rightAnchor.constraint(equalTo: self.rightAnchor),
            TVCollection.heightAnchor.constraint(equalToConstant: collectionHeight)
        ])
    }

    /**
     Calls the API retrieval of top rated movies in the Request class and applies the results to the list of TVItems
     */
    private func getTopRatedMovies() {
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
    
    /**
     Calls the API retrieva of popular movies  in the Request class and applies the results to the list of TVItems
     */
    private func getPopularMovies() {
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
    
    /**
     Calls the API retrieval of popular shows in the Request class and applies the results to the list of TVItems
     */
    private func getPopularShows() {
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
    
    /**
     Calls the API retrieval of popular people  in the Request class and applies the results to the list of TVItems
     */
    private func getPopularPeople() {
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
    
    /**
     Calls the API retrieval of top rated shows in the Request class and applies the results to the list of TVItems
     */
    private func getTopRatedShows() {
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
    
    /**
     Calls the API retrieval of upcoming movies in the Request class and applies the results to the list of TVItems
     */
    private func getUpcomingMovies() {
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
    
    /**
     Calls the API retrieval of the poster image of a TVItem in the Request class and returns the image location when escaping
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
     Sets all attributes of the cells in the collection to their defaults
     */
    private func setCellDefaults(cell: TVCell, item: TVItem) {
        cell.setItem(item: item)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 5
        
        if(item.title != nil) {
            //Case Movie
            cell.titleLabel.text = item.title
            cell.imageView.image = UIImage(named: "movie_default.jpg")
            
        } else if(item.known_for_department != nil) {
            //Case Actor
//            cell.typeLabel.text = "Person"
            cell.titleLabel.text = item.name
            cell.imageView.image = UIImage(named: "profile_default.jpg")
            
        } else {
            //Case Show
            cell.titleLabel.text = item.name
            cell.imageView.image = UIImage(named: "movie_default.jpg")
            
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
                                cell.ratingView.widthAnchor.constraint(equalToConstant: cell.ratingView.calculateWidth(item: item)).isActive = true
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
                                cell.ratingView.widthAnchor.constraint(equalToConstant: cell.ratingView.calculateWidth(item: item)).isActive = true
                        }
                    }
                }
            }
        }
    }
    
}

extension TVCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    /**
     Returns the number of cells in the list
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return TVList.count
    }

    /**
     Returns a cell with the information of a specifc index of the list of TVItems to display in this collection
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = TVCollection.dequeueReusableCell(withReuseIdentifier: TVCellID, for: indexPath) as! TVCell
        cell.tag = indexPath.row
       let item = TVList[indexPath.row]
       setCellDefaults(cell: cell, item: item)
       getCellImage(cell: cell, item: item)
       return cell
    }

    /**
     Navigates to the details page of the TVItem represented by this cell when it is tapped
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let item:TVItem = TVList[indexPath.row]
       navDelegate?.cellTapped(item)
    }

    /**
     Returns the dimensions of the cell
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: cellWidth, height: cellHeight)
    }

    /**
     Returns the size of the insets around the cell
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: cellInsetSize, left: cellInsetSize, bottom: cellInsetSize, right: cellInsetSize)
    }
}
