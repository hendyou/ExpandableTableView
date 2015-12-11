//
//  ExpandableView.swift
//  ExpandableTableView
//
//  Created by Hendy on 15/12/10.
//  Copyright © 2015年 Hendy's MacMini. All rights reserved.
//

import UIKit

@objc protocol ExpandableViewDelegate: NSObjectProtocol {
    optional func mayChangeHeight(height: CGFloat, expandableView: ExpandableView);
}

class ExpandableView: UIView, ExpandableTableStateDelegate {

    private static let defaultAnimDuration = 0.3
    
    var expandableTableDelegate: ExpandableTableViewDelegate?
    var expnadableViewDelegate: ExpandableViewDelegate?
    
    var mainView: UIView?
    var dividerView = UIView(frame: CGRectMake(0, 0, 0, 1))
    var expandableTableView: ExpandableTableView?
    
    var tableMaxHeight: CGFloat = -1
    var animDuration = defaultAnimDuration
    var collpaseAllWhenShowing = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let main = mainView {
            
            if main.superview == nil {
//                MainView
                var frame = main.frame
                frame.size.width = self.frame.width
                main.frame = frame
                
                main.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleBottomMargin]
                addSubview(main)
                
//                Divider
                frame = dividerView.frame
                frame.size.width = self.frame.width
                frame.origin.y = main.frame.origin.y + main.frame.height
                dividerView.frame = frame
                
                dividerView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleBottomMargin]
                addSubview(dividerView)
            }
            
        }

        
        
    }
    
    func setViews() {
        clipsToBounds = true
        dividerView.backgroundColor = UIColor.lightGrayColor()
    }
    
    func showTable() {
        if isShowingTable() {
            return
        }
        
        if let tableDelegate = expandableTableDelegate {
            if expandableTableView == nil {
                expandableTableView = ExpandableTableView(frame: CGRectMake(0, dividerView.frame.origin.y + dividerView.frame.height, self.frame.width, 0))
                expandableTableView!.expandableTableViewDelegate = tableDelegate
                expandableTableView!.expandableTableStateDelegate = self
                
                expandableTableView!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleBottomMargin]
            }
            
            addSubview(expandableTableView!)
            
            expnadableViewDelegate?.mayChangeHeight?(calculateHeight(), expandableView: self)
            UIView.animateWithDuration(0.3) { () -> Void in
                self.resetTableHeight()
            }
        }
    }
    
    func hideTable() {
        if isShowingTable() {
            var height: CGFloat = 0
            
            if let main = mainView {
                height += main.frame.size.height
            }
            
            var frame = self.frame
            frame.size.height = height
            expnadableViewDelegate?.mayChangeHeight?(height, expandableView: self)
            if collpaseAllWhenShowing {
                expandableTableView?.collapseAll()
            }
            self.expandableTableView?.performSelector("removeFromSuperview", withObject: nil, afterDelay: animDuration)
            
        }
    }
    
    func isShowingTable() -> Bool {
        if let table = expandableTableView {
            if let _ = table.superview {
                return true
            }
        }
        
        return false
    }
    
    private func resetTableHeight() {
        if let table = expandableTableView {
            var tHeight = table.tableHeight()
            if tableMaxHeight >= 0 && tHeight > tableMaxHeight {
                tHeight = tableMaxHeight
            }
            
            var frame = table.frame
            frame.size.height = tHeight
            table.frame = frame
        }
    }
    
    private func calculateHeight() -> CGFloat {
        var height: CGFloat = 0
        
        if let main = mainView {
            height += main.frame.height
            height += dividerView.frame.height
        }
        
        if let table = expandableTableView {
            if let _ = table.superview {
                var tHeight = table.tableHeight()
                if tableMaxHeight >= 0 && tHeight > tableMaxHeight {
                    tHeight = tableMaxHeight
                }
                
                height += tHeight
            }
        }
        return height
    }
    
//  MARK: - ExpandableTableStateDelegate
    func mayChangeHeight(height: CGFloat) {
        expnadableViewDelegate?.mayChangeHeight?(calculateHeight(), expandableView: self)
        UIView.animateWithDuration(animDuration) { () -> Void in
            self.resetTableHeight()
        }
    }
}
