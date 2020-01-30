//
//  FavoritesViewController.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/29/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController, NavigationDelegate {
    
    let searchBarHeight:CGFloat = 30
    
    private var favoritesCollection:FavoritesCollection = {
        let collection = FavoritesCollection()
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    init() {
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        createElementsAndConstraints()
        setUpDelegates()
    }
    
    func setUpDelegates() {
        favoritesCollection.navDelegate = self
    }
    
    func createElementsAndConstraints() {
        view.addSubview(favoritesCollection)
        searchCollectionConstraints()
    }
    
    func searchCollectionConstraints() {
        NSLayoutConstraint.activate([
            favoritesCollection.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            favoritesCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            favoritesCollection.leftAnchor.constraint(equalTo: view.leftAnchor),
            favoritesCollection.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func cellTapped(_ item: TVItem) {
        navigationController?.pushViewController(DetailViewController(item: item), animated: true)
    }
}
