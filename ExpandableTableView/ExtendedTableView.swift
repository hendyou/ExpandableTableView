//
//  ExpandableView.swift
//  ExpandableTableView
//
//  Created by Hendy on 15/12/10.
//  Copyright © 2015年 Hendy's MacMini. All rights reserved.
//

import UIKit

class ExtendedTableView: ExtendedView, ExpandableTableStateDelegate {

    private static let defaultAnimDuration = 0.3
    private static let kHeight = "Height"
    
    var expandableTableDelegate: ExpandableTableViewDelegate?
    
    var expandableTableView: ExpandableTableView?
    
    var tableMaxHeight: CGFloat = -1
    var collpaseAllWhenShowing = true
    
    override func showExtendedView() {
        if let tableDelegate = expandableTableDelegate {
            if expandableTableView == nil {
                expandableTableView = ExpandableTableView(frame: CGRectMake(0, dividerView.frame.origin.y + dividerView.frame.height, self.frame.width, 0))
                expandableTableView!.expandableTableViewDelegate = tableDelegate
                expandableTableView!.expandableTableStateDelegate = self
                
                expandableTableView!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleBottomMargin]
                
                extendedView = expandableTableView
            }
            
        }
        super.showExtendedView()
    }
    
    override func hideExtendedView() {
        super.hideExtendedView()
        
        if collpaseAllWhenShowing {
            expandableTableView?.collapseAll()
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
    
    override func extendedViewHeight() -> CGFloat {
        var height: CGFloat = 0
        if let table = expandableTableView {
            if let _ = table.superview {
                var tHeight = table.tableHeight()
                if tableMaxHeight >= 0 && tHeight > tableMaxHeight {
                    tHeight = tableMaxHeight
                }
                
                height = tHeight
            }
        }
        return height
    }
    
    
//  MARK: - ExpandableTableStateDelegate
    func mayChangeHeight(height: CGFloat) {
        if let table = expandableTableView {
            refreshHeight()
            
            var frame = table.frame
            frame.size.height = height
            UIView.animateWithDuration(animDuration) { () -> Void in
                table.frame = frame
            }
        }
    }
}
