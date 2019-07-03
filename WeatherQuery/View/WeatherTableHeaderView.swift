//
//  WeatherTableHeaderView.swift
//  WeatherQuery
//
//  Created by Yuangang Sheng on 2019/7/3.
//  Copyright © 2019 Johnny. All rights reserved.
//

import UIKit

class WeatherTableHeaderView: UIView {
    
    var mainSubview: WeatherMainView?
    
    var tableView: UITableView?
    var maximumOffsetY: CGFloat?
    
    fileprivate let minViewHeight:CGFloat = 50.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(subview: UIView, andType type: Int) {
        super.init(frame: subview.frame)
        
        self.initialSetupForCustomSubView(subview: subview)
    }
    
    func initialSetupForCustomSubView(subview: UIView) {
        self.mainSubview = subview as? WeatherMainView
        self.mainSubview!.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleHeight, .flexibleWidth]
        
        assert(mainSubview != nil, "mainSubview initialize failed")
        
        self.addSubview(mainSubview!)
        updateSwitch()
        
    }
    
    func updateSwitch() {
        self.mainSubview?.tempSwitch.setOn(UserDefaultManager.switchStatus(), animated: false)
    }
    
    
    func layoutHeaderViewForScrollViewOffset(offset: CGPoint) {
        updateHeaderView(offset: offset)
    }
    
    func updateHeaderView(offset: CGPoint) {
        //50 is the height of table view cell
        let totalDis = frame.size.height - minViewHeight
        
        self.mainSubview?.switchStackView.isHidden = true
        
        //limit to 50 height
        if offset.y > totalDis {
            var frame = self.mainSubview!.frame
            frame.origin.y = offset.y
            frame.size.height  = minViewHeight
            self.mainSubview?.frame = frame
            
            let goalRect = self.mainSubview!.tempLabelDestinationRect!
            self.mainSubview?.tempLabel.frame = goalRect
             self.clipsToBounds = false
        } else {//scroll up
            var delta: CGFloat = 0
            delta = offset.y
            //new
            let movePercent = delta/totalDis
            var newRect = self.mainSubview!.tempLableOriginalRect!
            let desRect = self.mainSubview!.tempLabelDestinationRect!
            newRect.origin.x += movePercent*(desRect.origin.x - newRect.origin.x)
            newRect.origin.y += movePercent*(desRect.origin.y - newRect.origin.y)
            self.mainSubview?.tempLabel.frame = newRect
            
            var rect = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            rect.origin.y += delta
            rect.size.height -= delta
            
            self.mainSubview!.frame = rect
            //
            if offset.y == 0 {
                self.mainSubview?.switchStackView.isHidden = false
            }
            
             self.clipsToBounds = false
        }
    }
}

