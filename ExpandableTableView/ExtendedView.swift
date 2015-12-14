//
//  ExtendedView.swift
//  ExpandableTableView
//
//  Created by Hendy on 15/12/14.
//  Copyright © 2015年 Hendy's MacMini. All rights reserved.
//

import UIKit

@objc protocol ExtendedViewDelegate: NSObjectProtocol {
    optional func mayChangeHeight(height: CGFloat, extendedView: ExtendedView);
}

class ExtendedView: UIView {

    private static let defaultAnimDuration = 0.3
    private static let kHeight = "Height"
    
    var extendedViewDelegate: ExtendedViewDelegate?

    var mainView: UIView?
    var dividerView = UIView(frame: CGRectMake(0, 0, 0, 1))
    var extendedView: UIView?
    
    var animDuration = defaultAnimDuration
    
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
    
    func showExtendedView() {
        if isShowingExtendedView() {
            return
        }
        
        if let view = extendedView {
            
            addSubview(view)
            
            updateHeight(calculateHeight())
            
            UIView.animateWithDuration(animDuration) { () -> Void in
                self.resetExtendedViewHeight()
            }
        }
    }
    
    func hideExtendedView() {
        if isShowingExtendedView() {
            var height: CGFloat = 0
            
            if let main = mainView {
                height = main.frame.size.height
            }
            
            var frame = self.frame
            frame.size.height = height
            
            updateHeight(height)
            
            self.extendedView?.performSelector("removeFromSuperview", withObject: nil, afterDelay: animDuration)
            
        } else {
            return
        }
    }
    
    func isShowingExtendedView() -> Bool {
        if let view = extendedView {
            if let _ = view.superview {
                return true
            }
        }
        
        return false
    }
    
    private func calculateHeight() -> CGFloat {
        var height: CGFloat = 0
        
        if let main = mainView {
            height += main.frame.height
            height += dividerView.frame.height
        }
        
        height += extendedViewHeight()
        
        return height
    }
    
    private func resetExtendedViewHeight() {
        if let view = extendedView {
            
            var frame = view.frame
            frame.size.height = extendedViewHeight()
            view.frame = frame
        }
    }
    
    func extendedViewHeight() -> CGFloat {
        return 0
    }
    
    private func updateHeight(height: CGFloat) {
        for var constraint in constraints {
            if ExtendedView.kHeight == constraint.identifier {
                constraint.constant = height
                
                var view = superview
                while view?.superview != nil {
                    view = view?.superview
                }
                
                if let v = view {
                    UIView.animateWithDuration(animDuration) { () -> Void in
                        v.layoutIfNeeded()
                    }
                }
                
                break
            }
        }
        
        extendedViewDelegate?.mayChangeHeight?(calculateHeight(), extendedView: self)
    }
    
    func refreshHeight() {
        updateHeight(calculateHeight())
    }

}
