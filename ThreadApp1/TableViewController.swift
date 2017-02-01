//
//  TableViewController.swift
//  ThreadApp1
//
//  Created by Vishwajeet Dagar on 1/25/17.
//  Copyright © 2017 Vishwajeet. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

var cache = NSCache<AnyObject, AnyObject>()

class TableViewController: UITableViewController {

    //MARK: Variables
    var imageid = [String]()
    var countRow = 7
    var operations = [Operation]()
    var queue = OperationQueue()
    var loadMoreStatus = false

    //MARK: Outlets
    @IBOutlet var table: UITableView!
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loadText: UILabel!
    
    let graphRequest = FBSDKGraphRequest(graphPath: "/me/photos", parameters: ["fields":"id"], httpMethod:"GET")
    
    //MARK: ViewLoad Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewMore.isHidden=true
        //tableView.rowHeight=UITableViewAutomaticDimension
        //tableView.estimatedRowHeight=300
        
        DispatchQueue.global().async {
            let _ = self.graphRequest?.start(completionHandler: {  (connection, result, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    if result != nil{
                        self.printphoto(data:result as! NSDictionary)
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.navigationController?.viewControllers.index(of: self)==NSNotFound{
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            let _=self.navigationController?.popViewController(animated: true)
        }
        super.viewWillDisappear(true)
    }
    
    
    //MARK: TableView Functions

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countRow
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row < operations.count {
            operations[indexPath.row].queuePriority = .veryHigh
        }
        if indexPath.row == countRow-1 {
            loadMore()
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row < operations.count {
            operations[indexPath.row].queuePriority = .veryLow
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? TableViewCell
            else{
                fatalError("Could not deque cell")
            }
        if imageid.count > indexPath.row{
            let url=URL(string: "https://graph.facebook.com/\(imageid[indexPath.row])/picture")
            let operation1:Operation? = cell.img.getimage(url: url!, cell: cell, animateIndicator: true)
            if operation1 != nil{
                self.operations+=[operation1!]
                queue.addOperation(operation1!)
            }
        }
        else{
            print("Images not yet obtained")
        }
        
        return cell
    }
    
    
    //MARK: Load Photo and Cache
    
    func printphoto(data: NSDictionary){
        if let jsondata1 = data["data"] as? [[String: Any]]  {
            for jsondata in jsondata1{
                let id = jsondata["id"] as! String
                imageid += [id]
                print(id)
            }
        }
    }
    
    
    
    //MARK: Infinite Scroll
    func loadMore() {
        if ( loadMoreStatus == false ) {
            self.loadMoreStatus = true
            self.indicator.startAnimating()
            self.viewMore.isHidden = false
            loadMoreBegin(loadMoreEnd: {(x:Int) -> () in
                            self.tableView.reloadData()
                            self.loadMoreStatus = false
                            self.indicator.stopAnimating()
                            self.viewMore.isHidden = true
            })
        }
    }
    
    func loadMoreBegin(loadMoreEnd:@escaping (Int) -> ()) {
        DispatchQueue.global().async {
            self.countRow += 7
            sleep(2)
            DispatchQueue.main.async() {
                loadMoreEnd(0)
            }
        }
    }
}

