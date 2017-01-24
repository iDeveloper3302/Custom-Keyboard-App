//
//  CustomCollectionView.swift
//  CustomKeyboard
//
//  Created by iDeveloper on 3/20/16.
//  Copyright © 2016 com.ideveloper. All rights reserved.
//

import UIKit
protocol CustomCollectionViewDelegate: class {
    func didSelectItem(item: EmojiItem, sender: CustomCollectionView)
    func didTapNextKeyButton(sender: UIButton)
    func didTapDeleteButton(sender: UIButton)

}

class CustomCollectionView: UIView {

    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    var view: UIView!
    var isShowLabel: Bool = true
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var noticeView: UIView!
    @IBOutlet weak var nextKeyButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    var imageSource: EmojiItemList? {
        didSet {
            collectionView?.reloadData()
        }
    }
    weak var delegate: CustomCollectionViewDelegate?

    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        }
    }
    override init(frame: CGRect) {
        // 1. setup any properties here

        // 2. call super.init(frame:)
        super.init(frame: frame)

        // 3. Setup view from .xib file
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here

        // 2. call super.init(coder:)
        super.init(coder: aDecoder)

        // 3. Setup view from .xib file
        xibSetup()
    }

    func xibSetup() {
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds

        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        view.backgroundColor = UIColor(red: 207/255, green: 209/255, blue: 213/255, alpha: 1)
        addSubview(view)
        setup()
    }

    //func isInternetAvaiable() -> Bool {
    //    let reachability: Reachability
   //     do {
   //         reachability = try Reachability.reachabilityForInternetConnection()
   //         return reachability.currentReachabilityStatus != .NotReachable
   //     } catch {
    //        print("Unable to create Reachability")
    //        return false
    //    }
    //}

    func setup() {
            let nib = UINib(nibName: "IconCellCollectionViewCell", bundle: nil)
            collectionView.registerNib(nib, forCellWithReuseIdentifier: "IconCell")
            collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
            collectionView.backgroundColor =  UIColor(red: 207/255, green: 209/255, blue: 213/255, alpha: 1)
            bottomView.backgroundColor = UIColor(red: 190/255, green: 192/255, blue: 196/255, alpha: 1)
            collectionView.delegate = self
            collectionView.dataSource = self


            //        nextKeyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
            //        nextKeyButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
            //        nextKeyButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            label.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
    //        nextKeyButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
    //        nextKeyButton.layer.shadowOffset = CGSizeMake(0.0, 2.0)
    //        nextKeyButton.layer.shadowOpacity = 1.0
    //        nextKeyButton.layer.shadowRadius = 0.0
    //        nextKeyButton.layer.masksToBounds = false
    //        nextKeyButton.layer.cornerRadius = 4.0

    //        deleteButton.backgroundColor = UIColor.whiteColor()
    //        deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
    //        deleteButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
    //        deleteButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    //
    //        deleteButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
    //        deleteButton.layer.shadowOffset = CGSizeMake(0.0, 2.0)
    //        deleteButton.layer.shadowOpacity = 1.0
    //        deleteButton.layer.shadowRadius = 0.0
    //        deleteButton.layer.masksToBounds = false
    //        deleteButton.layer.cornerRadius = 4.0
            //        nextKeyButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)



    }

    var timer: NSTimer?

    @IBAction func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(handleTimer(_:)), userInfo: nil, repeats: true)
        } else if sender.state == .Ended || sender.state == .Cancelled {
            timer?.invalidate()
            timer = nil
        }
    }

    func handleTimer(timer: NSTimer) {
        delegate?.didTapDeleteButton(deleteButton)
    }

    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CustomCollectionView", bundle: bundle)
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

    @IBAction func nextKeyButtonPressed(sender: UIButton) {
        delegate?.didTapNextKeyButton(nextKeyButton)
    }
    @IBAction func deleteButtonPressed(sender: UIButton) {
        delegate?.didTapDeleteButton(deleteButton)
    }
}


extension CustomCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSource?.items.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("IconCell", forIndexPath: indexPath)

        if let cell = cell as? IconCellCollectionViewCell {
            cell.item = imageSource?.items[indexPath.row]
        }


        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let margin = self.returnMarginFromDevice()
        let marginHeight = self.returnMarginHeightFromDevice()
        return CGSize(width: collectionView.bounds.width/9 + CGFloat(margin), height: collectionView.bounds.width/9 + CGFloat(marginHeight))
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let delegate = delegate, item = imageSource?.items[indexPath.row] {

            //if(!self.isInternetAvaiable()) {
            //    self.errorView.alpha = 1
            //    self.errorView.hidden = false
                self.label.alpha = 0.0
           //     UIView.animateWithDuration(3.0, animations: {
          //          self.errorView.alpha = 0.0
           //         self.label.alpha = 1.0
           //     })

           // } else {
                let cell: IconCellCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! IconCellCollectionViewCell
                cell.imageView.alpha = 0.2
                cell.bottomView.alpha = 1
                self.noticeView.alpha = 1

                cell.imageView.fadeIn(duration: 0.5)

                if isShowSmallLabel() {
                    self.noticeView.hidden = true
                    cell.bottomView.hidden = false

                    cell.bottomView.fadeOut(duration: 3)
                } else {
                    self.noticeView.hidden = false
                    cell.bottomView.hidden = true
                     self.label.alpha = 0.0
                    UIView.animateWithDuration(3.0, animations: {
                        self.noticeView.alpha = 0.0
                        self.label.alpha = 1.0
                    })
                }
                self.isShowLabel = false
                UIView.animateWithDuration(5, animations : {
                    self.isShowLabel = false
                    }, completion: { (finished: Bool) -> Void in
                        //                self.isShowLabel = true
                        //                     self.label.hidden = !isShowLabel
                })

                delegate.didSelectItem(item, sender: self)
           // }
        }
    }

    func isShowSmallLabel() -> Bool {
        return false
        let defaults = NSUserDefaults.standardUserDefaults()
        var value = defaults.integerForKey("countNumberLabel")
        value -= 1
        defaults.setInteger(value, forKey: "countNumberLabel")
        if value < 1 {
            return true
        } else {
            return false
        }
    }


    //
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}


public extension UIView {

    /**
     Fade in a view with a duration

     - parameter duration: custom animation duration
     */
    func fadeIn(duration duration: NSTimeInterval = 1.0) {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 1.0
        })
    }

    /**
     Fade out a view with a duration

     - parameter duration: custom animation duration
     */
    func fadeOut(duration duration: NSTimeInterval = 3.0) {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 0.0
        })
    }

    func returnMarginFromDevice() -> Int {
        let height = UIScreen.mainScreen().bounds.height
        if height < 568 {
            return 10
        } else if (height < 667 && height >= 568) {
            return 10
        } else if (height < 736 && height >= 667) {
            return 13
        } else if (height < 1024 && height >= 736) {
            return 13
        } else if (height < 2048 && height >= 1024) {
            return 0
        } else if (height < 2732  && height >= 2048) {
            return 0
        } else if (height >= 2732) {
            return 0
        }
        return 0
    }

    func returnMarginHeightFromDevice() -> Int {
        let height = UIScreen.mainScreen().bounds.height
        if height < 568 {
            return 5
        } else if (height < 667 && height >= 568) {
            return 5
        } else if (height < 736 && height >= 667) {
            return 6
        } else if height >= 736 {
            return 6
        }
        return 0
    }

}
