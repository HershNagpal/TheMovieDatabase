//
//  BrowseViewControllerOld.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/21/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import UIKit

class BrowseViewController2: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let movieRequest = Request()
    
    var topRatedMovies = [TVItem]()
    var upcomingMovies = [TVItem]()
    var trendingMovies = [TVItem]()
    
    let topRatedMovieCellID:String = "CellID"
    let trendingMovieCellID:String = "CellID"
    let upcomingMovieCellID:String = "CellID"
    
    let labelHeight:CGFloat = 30
    let collectionHeight:CGFloat = 210
    let cellHeight:CGFloat = 200
    let cellWidth:CGFloat = 140
    let searchBarHeight:CGFloat = 50
    
    let backgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = .magenta
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topRatedMoviesCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x:0, y:0, width:0, height:0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = .magenta
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        return collection
    }()
    
    let trendingMoviesCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x:0, y:0, width:0, height:0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = UIColor.gray
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        return collection
    }()
    
    let upcomingMoviesCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x:0, y:0, width:0, height:0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = UIColor.gray
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        return collection
    }()
    
    let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.text = "Your Last Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let topRatedMoviesLabel:UILabel = {
        let label = UILabel()
        label.text = "Top Rated Movies"
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let trendingMoviesLabel:UILabel = {
        let label = UILabel()
        label.text = "Trending Movies"
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let upcomingMoviesLabel:UILabel = {
        let label = UILabel()
        label.text = "Upcoming Movies"
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTopRatedMovies()
        registerCollectionCellsAndDelegates()
        createElementsAndConstraints()
    }
    
    func registerCollectionCellsAndDelegates() {
        topRatedMoviesCollection.delegate = self
        topRatedMoviesCollection.dataSource = self
        topRatedMoviesCollection.register(MovieShowCell.self, forCellWithReuseIdentifier: topRatedMovieCellID)
        
        trendingMoviesCollection.delegate = self
        trendingMoviesCollection.dataSource = self
        trendingMoviesCollection.register(MovieShowCell.self, forCellWithReuseIdentifier: trendingMovieCellID)
        
        upcomingMoviesCollection.delegate = self
        upcomingMoviesCollection.dataSource = self
        upcomingMoviesCollection.register(MovieShowCell.self, forCellWithReuseIdentifier: upcomingMovieCellID)
    }
    
    func createElementsAndConstraints() {
        view.addSubview(backgroundView)
        view.addSubview(searchBar)
        view.addSubview(topRatedMoviesLabel)
        view.addSubview(topRatedMoviesCollection)
        view.addSubview(trendingMoviesLabel)
        view.addSubview(trendingMoviesCollection)
        view.addSubview(upcomingMoviesLabel)
        view.addSubview(upcomingMoviesCollection)
        backgroundViewConstraints()
        searchBarConstraints()
        topRatedMoviesLabelConstraints()
        topRatedMoviesCollectionConstraints()
        trendingMoviesLabelConstraints()
        trendingMoviesCollectionConstraints()
        upcomingMoviesLabelConstraints()
        upcomingMoviesCollectionConstraints()
    }
    
    func backgroundViewConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func searchBarConstraints() {
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: searchBarHeight/2),
            searchBar.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: searchBarHeight)
        ])
    }
    
    func topRatedMoviesLabelConstraints() {
        NSLayoutConstraint.activate([
            topRatedMoviesLabel.centerYAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: labelHeight/2),
            topRatedMoviesLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            topRatedMoviesLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            topRatedMoviesLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            topRatedMoviesLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
    }
    
    func trendingMoviesLabelConstraints() {
        NSLayoutConstraint.activate([
            trendingMoviesLabel.centerYAnchor.constraint(equalTo: topRatedMoviesCollection.bottomAnchor, constant: labelHeight/2),
            trendingMoviesLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            trendingMoviesLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            trendingMoviesLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            trendingMoviesLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
    }
    
    func upcomingMoviesLabelConstraints() {
        NSLayoutConstraint.activate([
            upcomingMoviesLabel.centerYAnchor.constraint(equalTo: trendingMoviesCollection.bottomAnchor, constant: labelHeight/2),
            upcomingMoviesLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            upcomingMoviesLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            upcomingMoviesLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            upcomingMoviesLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
    }
    
    func topRatedMoviesCollectionConstraints() {
        NSLayoutConstraint.activate([
            topRatedMoviesCollection.topAnchor.constraint(equalTo: topRatedMoviesLabel.bottomAnchor),
            topRatedMoviesCollection.leftAnchor.constraint(equalTo: view.leftAnchor),
            topRatedMoviesCollection.rightAnchor.constraint(equalTo: view.rightAnchor),
            topRatedMoviesCollection.heightAnchor.constraint(equalToConstant: collectionHeight)
        ])
    }
    
    func trendingMoviesCollectionConstraints() {
        NSLayoutConstraint.activate([
            trendingMoviesCollection.topAnchor.constraint(equalTo: trendingMoviesLabel.bottomAnchor),
            trendingMoviesCollection.leftAnchor.constraint(equalTo: view.leftAnchor),
            trendingMoviesCollection.rightAnchor.constraint(equalTo: view.rightAnchor),
            trendingMoviesCollection.heightAnchor.constraint(equalToConstant: collectionHeight)
        ])
    }
    
    func upcomingMoviesCollectionConstraints() {
        NSLayoutConstraint.activate([
            upcomingMoviesCollection.topAnchor.constraint(equalTo: upcomingMoviesLabel.bottomAnchor),
            upcomingMoviesCollection.leftAnchor.constraint(equalTo: view.leftAnchor),
            upcomingMoviesCollection.rightAnchor.constraint(equalTo: view.rightAnchor),
            upcomingMoviesCollection.heightAnchor.constraint(equalToConstant: collectionHeight)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topRatedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = topRatedMoviesCollection.dequeueReusableCell(withReuseIdentifier: topRatedMovieCellID, for: indexPath) as! MovieShowCell
        
        let item = topRatedMovies[indexPath.row]
        cell.backgroundColor = .white
        cell.titleLabel.text = item.title ?? "Untitled Movie Lol"
        
        
        
        
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
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func getImage(searchTerms: String, completion: @escaping(Result<Data, Error>) -> Void) {
        movieRequest.getImage(searchTerms: searchTerms) { [weak self] result in
        completion(result)
        }
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
    
    func getTrendingMovies() {
        movieRequest.getTrendingMovies { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let items):
                self?.trendingMovies = items
                DispatchQueue.main.async {
                    self?.trendingMoviesCollection.reloadData()
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
                self?.upcomingMovies = items
                DispatchQueue.main.async {
                    self?.upcomingMoviesCollection.reloadData()
                }
            }
            
        }
    }
    
}


extension BrowseViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    

}
