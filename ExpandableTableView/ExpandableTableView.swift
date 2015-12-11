//
//  ExpandableTableView.swift
//  ExpandableTableView
//
//  Created by Hendy on 15/12/7.
//  Copyright © 2015年 Hendy's MacMini. All rights reserved.
//

import UIKit

@objc protocol ExpandableTableViewDelegate: NSObjectProtocol {
    func numberOfSections(expandableTableView tableView: UITableView) -> Int
    func numberOfRowsInSection(section: Int, expandableTableView: UITableView) -> Int
    func cellForSection(section: Int, expandableTableView: UITableView) -> UITableViewCell
    func cellForRow(row: Int, section: Int, expandableTableView: UITableView) -> UITableViewCell
    
    optional func heightForSection(section: Int, expandableTableView: UITableView) -> CGFloat
    optional func heightForRow(row: Int, section: Int,expandableTableView: UITableView) -> CGFloat
    
    optional func didSelectRow(row: Int, section: Int, expandableTableView: UITableView)
    optional func didExpandSection(section: Int, expandableTableView: UITableView)
    optional func didCollapseSection(section: Int, expandableTableView: UITableView)
}

@objc protocol ExpandableTableStateDelegate: NSObjectProtocol {
    optional func mayChangeHeight(height: CGFloat)
}

class ExpandableTableView: UITableView, UITableViewDataSource, UITableViewDelegate  {
    private let defaultRowHeight: CGFloat = 44
    
    var expandableTableViewDelegate: ExpandableTableViewDelegate?
    var expandableTableStateDelegate: ExpandableTableStateDelegate?
    var onlyOneExpanded = true
    
    private var indexSet = NSMutableIndexSet()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
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
    
    func setViews() {
        dataSource = self
        delegate = self
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let _delegate = expandableTableViewDelegate {
            return _delegate.numberOfSections(expandableTableView: self)
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if indexSet.containsIndex(section) {
            if let _delegate = expandableTableViewDelegate {
                return _delegate.numberOfRowsInSection(section, expandableTableView: self) + 1
            }
        }
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if indexPath.row == 0 {
            cell = expandableTableViewDelegate?.cellForSection(indexPath.section, expandableTableView: self)
        } else {
            cell = expandableTableViewDelegate?.cellForRow(indexPath.row - 1, section: indexPath.section, expandableTableView: self)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0 {
            if indexSet.containsIndex(indexPath.section) {
                collapseData(section: indexPath.section)
            } else {
                expandData(section: indexPath.section)
            }
            expandableTableStateDelegate?.mayChangeHeight?(tableHeight())
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let tableDelegate = expandableTableViewDelegate {
            if tableDelegate.respondsToSelector("heightForSection:expandableTableView:") && indexPath.row == 0{
                return tableDelegate.heightForSection!(indexPath.section, expandableTableView: self)
            } else if tableDelegate.respondsToSelector("heightForRow:section:expandableTableView:") && indexPath.row != 0 {
                return tableDelegate.heightForRow!(indexPath.row - 1, section: indexPath.section, expandableTableView: self)
            }
        }
        return defaultRowHeight
    }
    
    func expandData(section section: Int) {
        if onlyOneExpanded {
            collapseAll()
        }
        
        if let _delegate = expandableTableViewDelegate {
            let count = _delegate.numberOfRowsInSection(section, expandableTableView: self)
            if count > 0 {
                indexSet.addIndex(section)
                
                var indexPaths = [NSIndexPath]()
                for var i = 0; i < count; i++ {
                    indexPaths.append(NSIndexPath(forRow: i + 1, inSection: section))
                }
                
                insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
                
                expandableTableViewDelegate?.didExpandSection?(section, expandableTableView: self)
            }
        }
        

    }
    
    func collapseData(section section: Int) {
        
        if let _delegate = expandableTableViewDelegate {
            let count = _delegate.numberOfRowsInSection(section, expandableTableView: self)
            
            indexSet.removeIndex(section)
            
            var indexPaths = [NSIndexPath]()
            for var i = 0; i < count; i++ {
                indexPaths.append(NSIndexPath(forRow: i + 1, inSection: section))
            }
            
            deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
            
            expandableTableViewDelegate?.didCollapseSection?(section, expandableTableView: self)
        }

    }
    
    func collapseAll() {
        if indexSet.count > 0 {
            for var i = 0; i < indexSet.count; i++ {
                collapseData(section: indexSet.firstIndex)
            }
        }
    }
    
    func tableHeight() -> CGFloat {
        var height: CGFloat = 0.0
        let sections = self.numberOfSections
        for var s = 0; s < sections; s++ {
            let rows = self.numberOfRowsInSection(s)
            for var r = 0; r < rows; r++ {
                height += tableView(self, heightForRowAtIndexPath: NSIndexPath(forRow: r, inSection: s))
            }
        }
        return height
    }
}
