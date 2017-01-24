//
//  CollectionViewCell.swift
//  CustomKeyboard
//
//  Created by iDeveloper on 3/20/16.
//  Copyright © 2016 com.ideveloper. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    var item: EmojiItem? {
        didSet {
            imageView.image = UIImage(named: item!.link)
        }
    }
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    func setupView() {
        imageView = UIImageView()
        self.addSubview(imageView)
    }
}
