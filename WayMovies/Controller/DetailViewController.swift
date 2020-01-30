//
//  DetailViewController.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/22/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {

    private let item: TVItem
    
    let detailView:DetailView = {
        let detailView = DetailView()
        detailView.translatesAutoresizingMaskIntoConstraints = false
        return detailView
    }()
    
    init(item: TVItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        self.item = TVItem(id:00)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createElementsAndConstraints()
    }
    
    func createElementsAndConstraints() {
        view.addSubview(detailView)
        detailView.setDetails(item: item)
        detailViewConstraints()
    }
    
    func detailViewConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailView.leftAnchor.constraint(equalTo: view.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
