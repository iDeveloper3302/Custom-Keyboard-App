//
//  IconCellCollectionViewCell.swift
//  CustomKeyboard
//
//  Created by iDeveloper on 3/18/16.
//  Copyright © 2016 com.ideveloper. All rights reserved.
//

import UIKit

class IconCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var copyLabel: UILabel!
    var item: EmojiItem? {
        didSet {
            imageView.image = UIImage(named: item!.link)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization codeádasdas
        bottomView.backgroundColor = UIColor(red: 0/255, green: 105/255, blue: 243/255, alpha: 1)
        let size = returnFontFromDevice()
        copyLabel.font =  UIFont(name: copyLabel.font.fontName, size: CGFloat(size))
    }
    
    func returnFontFromDevice() -> Int {
        let height = UIScreen.mainScreen().bounds.height
        if height < 568 {
            return 5
        } else if (height < 667 && height >= 568) {
            return 7
        } else if (height < 736 && height >= 667) {
            return 7
        } else if height >= 736 {
            return 7
        }
        return 7
    }
}
