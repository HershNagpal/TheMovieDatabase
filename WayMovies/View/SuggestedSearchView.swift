//
//  SuggestedSearchView.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 2/19/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import UIKit

class SuggestedSearchView: UIView {

    private let suggestionTable:UIStackView = {
        let suggestionList = UIStackView()
        suggestionList.axis = .vertical
        suggestionList.distribution = .fillEqually
        suggestionList.translatesAutoresizingMaskIntoConstraints = false
        return suggestionList
    }()
    
    private let byActorButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.translucentGreen
        button.setTitle("Actor", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let byMovieButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.translucentGreen
        button.setTitle("Movie", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let byShowButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.translucentGreen
        button.setTitle("Show", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createElementsAndConstraints()
    }
    
     /**
     Adds all elements to the subview and calls constraining helper methods.
     */
    private func createElementsAndConstraints() {
        self.addSubview(suggestionTable)
        suggestionTable.addArrangedSubview(byActorButton)
        suggestionTable.addArrangedSubview(byMovieButton)
        suggestionTable.addArrangedSubview(byShowButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
