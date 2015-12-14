//
//  ViewController2.swift
//  ExpandableTableView
//
//  Created by Hendy on 15/12/10.
//  Copyright © 2015年 Hendy's MacMini. All rights reserved.
//

import UIKit

class ViewController2: UIViewController, ExpandableTableViewDelegate, ExpandableViewDelegate {

    @IBOutlet var expandableView: ExpandableView!
    @IBOutlet var viewHeight: NSLayoutConstraint!
    
    let array = ["Title1", "Title2", "Title3", "Title4"]
    let subArray = ["Sub1", "Sub2", "Sub3", "Sub4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        expandableView.layer.borderWidth = 1
        expandableView.layer.borderColor = UIColor.blueColor().CGColor
        expandableView.layer.cornerRadius = 6
        expandableView.backgroundColor = UIColor.clearColor()
        expandableView.expandableTableDelegate = self
        expandableView.expnadableViewDelegate = self
        
        let button = UIButton(type: UIButtonType.System)
        button.frame = CGRectMake(0, 0, 0, 60)
        button.setTitle("ShowTable", forState: UIControlState.Normal)
        expandableView.mainView = button
        
        button.addTarget(self, action: "click:", forControlEvents: UIControlEvents.TouchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//  MARK: - Actions
    func click(sender: AnyObject) {
        if expandableView.isShowingTable() {
            expandableView.hideTable()
        } else {
            expandableView.showTable()
        }
    }
    
//  MARK: - ExpandableTableViewDelegate
    func numberOfSections(expandableTableView tableView: UITableView) -> Int {
        return array.count
    }
    func numberOfRowsInSection(section: Int, expandableTableView: UITableView) -> Int {
        return subArray.count
    }
    func cellForSection(section: Int, expandableTableView: UITableView) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = array[section]
        return cell
    }
    func cellForRow(row: Int, section: Int, expandableTableView: UITableView) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: "subCell")
        
        cell.textLabel?.text = subArray[row]
        
        return cell
    }
    
//  MARK: - ExpandableViewDelegate
    func mayChangeHeight(height: CGFloat, expandableView: ExpandableView) {
        /* If set the identifier of ExpandableView hegiht constraint to "Height", no need this  */
//        viewHeight.constant = height
//        UIView.animateWithDuration(0.3) { () -> Void in
//            self.view.layoutIfNeeded()
//        }
    }
}
