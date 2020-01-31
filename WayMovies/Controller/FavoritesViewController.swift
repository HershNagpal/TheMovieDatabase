//
//  FavoritesViewController.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/29/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    
    let searchBarHeight:CGFloat = 30
    
    private var favoritesCollection:FavoritesCollection = {
        let collection = FavoritesCollection()
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    let backgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        view.addSubview(backgroundView)
        view.addSubview(favoritesCollection)
        backgroundViewConstraints()
        searchCollectionConstraints()
    }
    
    func backgroundViewConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func searchCollectionConstraints() {
        NSLayoutConstraint.activate([
            favoritesCollection.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            favoritesCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            favoritesCollection.leftAnchor.constraint(equalTo: view.leftAnchor),
            favoritesCollection.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

}


extension FavoritesViewController:NavigationDelegate {
    func cellTapped(_ item: TVItem) {
        navigationController?.pushViewController(DetailViewController(item: item), animated: true)
    }
}
