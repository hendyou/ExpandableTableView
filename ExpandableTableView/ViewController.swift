//
//  ViewController.swift
//  ExpandableTableView
//
//  Created by Hendy on 15/12/7.
//  Copyright © 2015年 Hendy's MacMini. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var array = ["TableView 1"]
    
    var indexSet = NSMutableIndexSet()
    
    var array1 = ["Title1", "Title2", "Title3", "Title4"]
    var subArray1 = ["Sub1", "Sub2", "Sub3", "Sub4"]
    
    var collapseAllWhenShowing = true
    var onlyOneExpanded = true

    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView1Height: NSLayoutConstraint!
    @IBOutlet var tableView2: UITableView!
    @IBOutlet var tableView2Height: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView1.layer.borderWidth = 1
        tableView1.layer.borderColor = UIColor.blackColor().CGColor
        tableView1.layer.cornerRadius = 6
        tableView1.reloadData()
        tableView1Height.constant = tableView1.contentSize.height
        
        tableView2.layer.borderWidth = 1
        tableView2.layer.borderColor = UIColor.blackColor().CGColor
        tableView2.layer.cornerRadius = 6
        tableView2.reloadData()
        tableView2Height.constant = tableView2.contentSize.height
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == tableView1 {
            return array.count
        }
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            if indexSet.containsIndex(section) {
                return subArray1.count + 1
            } else {
                return 1
            }
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if tableView == tableView1 {
            
            if indexPath.row == 0 {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
                cell.textLabel?.text = array[indexPath.section]
            } else {
                cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: "subCell")
                cell.textLabel?.text = subArray1[indexPath.row - 1]
            }
        } else if tableView == tableView2 {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell.textLabel?.text = "TableView 2"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == tableView1 {
            if indexPath.section == 0 {
                if tableView1.numberOfSections > 1 {
                    hideData()
                } else {
                    showData()
                }
            } else if indexPath.row == 0 {
                if indexSet.containsIndex(indexPath.section) {
                    collapseData(section: indexPath.section)
                } else {
                    expandData(section: indexPath.section)
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    
    func showData() {
        let indexSets = NSMutableIndexSet()
        for var i = 0; i < array1.count; i++ {
            indexSets.addIndex(i + 1)
        }
        
        array += array1
        
        tableView1.insertSections(indexSets, withRowAnimation: UITableViewRowAnimation.Fade)
        
        tableView1Height.constant = tableHeight()
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    func hideData() {
        let indexSets = NSMutableIndexSet()
        for var i = 1; i < tableView1.numberOfSections; i++ {
            indexSets.addIndex(i)
            array.removeLast()
        }
        
        tableView1.deleteSections(indexSets, withRowAnimation: UITableViewRowAnimation.Fade)
        
        tableView1Height.constant = tableView(tableView1, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutIfNeeded()
        }
        
        if collapseAllWhenShowing {
            indexSet.removeAllIndexes()
        }
    }
    
    func expandData(section section: Int) {
        if onlyOneExpanded && indexSet.count > 0 {
            for var i = 0; i < indexSet.count; i++ {
                collapseData(section: indexSet.firstIndex)
            }
        }
        
        indexSet.addIndex(section)
        
        var indexPaths = [NSIndexPath]()
        for var i = 0; i < subArray1.count; i++ {
            indexPaths.append(NSIndexPath(forRow: i + 1, inSection: section))
        }
        
        tableView1.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        
        tableView1Height.constant = tableHeight()
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    func collapseData(section section: Int) {
        indexSet.removeIndex(section)
        
        var indexPaths = [NSIndexPath]()
        for var i = 0; i < subArray1.count; i++ {
            indexPaths.append(NSIndexPath(forRow: i + 1, inSection: section))
        }
        
        tableView1.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        
        tableView1Height.constant = tableHeight()
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    func tableHeight()->CGFloat {
        var height: CGFloat = 0.0
        let sections = tableView1.numberOfSections
        for var s = 0; s < sections; s++ {
            let rows = tableView1.numberOfRowsInSection(s)
            for var r = 0; r < rows; r++ {
                height += tableView(tableView1, heightForRowAtIndexPath: NSIndexPath(forRow: r, inSection: s))
            }
        }
        return height
    }
}

