//
//  ContentView.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/20/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import UIKit

var preferredFont:UIFont = .init()
var preferredTextColor:UIColor = .white

class HomeViewController: UIViewController {
    
    let moveUpHeight:CGFloat = 100
    
    let backgroundImage:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "movie_default.jpg")
        image.tintColor = .black
        return image
    }()
    
    let blur:UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffect = UIVisualEffectView(effect: blur)
        blurEffect.translatesAutoresizingMaskIntoConstraints = false
        return blurEffect
    } ()
    
    let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let homeLabel:UILabel = {
        let label = UILabel()
        label.text = "Search for Movies, Actors, and TV Shows"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let browseButton:UIButton = {
        let button = UIButton()
        button.setTitle("Browse", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(browseButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        createElementsAndConstraints()
    }
    
    func createElementsAndConstraints() {
        view.addSubview(backgroundImage)
        view.addSubview(blur)
        view.addSubview(searchBar)
        view.addSubview(homeLabel)
        view.addSubview(browseButton)
        backgroundImageConstraints()
        blurConstraints()
        searchBarConstraints()
        homeLabelConstraints()
        browseButtonConstraints()
        blur.isHidden = true
    }
    
    func backgroundImageConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func blurConstraints() {
        NSLayoutConstraint.activate([
            blur.topAnchor.constraint(equalTo: view.topAnchor),
            blur.leftAnchor.constraint(equalTo: view.leftAnchor),
            blur.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blur.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func searchBarConstraints() {
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            searchBar.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor)
        ])
    }
    
    func homeLabelConstraints() {
        NSLayoutConstraint.activate([
            homeLabel.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -10),
            homeLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            homeLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            homeLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor)
        ])
    }
    
    func browseButtonConstraints() {
        NSLayoutConstraint.activate([
            browseButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            browseButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            browseButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func browseButtonClicked() {
        navigationController?.pushViewController(BrowseViewController(), animated: true)
    }
    
    func fadeInBlur() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.blur.alpha = 1.0
        }, completion: nil)
    }

    func fadeOutBlur() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.blur.alpha = 0.0
        }, completion: nil)
    }
    
    func moveElementsUp() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.searchBar.frame.origin.y -= self.moveUpHeight
            self.homeLabel.frame.origin.y -= self.moveUpHeight
            self.browseButton.frame.origin.y -= self.moveUpHeight
        }, completion: nil)
    }
    
    func moveElementsDown() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.searchBar.frame.origin.y += self.moveUpHeight
            self.homeLabel.frame.origin.y += self.moveUpHeight
            self.browseButton.frame.origin.y += self.moveUpHeight
        }, completion: nil)
    }
    
}

extension HomeViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Request.searchMulti(searchTerms: searchBar.text!) { [weak self] result in
        switch result {
             case .failure(let error):
                 print(error)
             case .success(let items):
                 DispatchQueue.main.async {
                    let vc = SearchViewController()
                    vc.applySearch(searchItems: items)
                    self?.navigationController?.pushViewController(vc, animated: true)
                 }
             }
         }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.blur.alpha = 0.0
        blur.isHidden = false
        moveElementsUp()
        fadeInBlur()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        fadeOutBlur()
        moveElementsDown()
        blur.isHidden = true
    }
}
