//
//  HeaderUIView.swift
//  MyProjectMovie
//
//  Created by Яна Угай on 10.01.2023.
//

import UIKit

class HeaderUIView: UIView {
    
    private lazy var headerView: UIView = { 
        let headerView = UIView()
        headerView.backgroundColor = .black
        return headerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
