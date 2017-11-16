//
//  ViewController.swift
//  Testing 1.0
//
//  Created by Savan Patel on 2016-02-18.
//  Copyright © 2016 Savan Patel. All rights reserved.
//

import UIKit

//Core location class will be inported here and through the instance of that class current location's coordinates will be first converted into double and then passed in to database.

class MainViewController: UICollectionViewController,UIPopoverPresentationControllerDelegate,UISearchBarDelegate {

    var Array = [String]();
    var nid = [Int]();
    var ntitle = [String]();
    var content = [String]();
    var category = [String]();
    var todayDate : NSDate = NSDate()
    var dateformatter :NSDateFormatter = NSDateFormatter();
    var date : String = "";
    var id = 0;
    var sortingType = "default";
    
    
    @IBOutlet var myCollectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        sorting();
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sorting();
        
        //hides back button when new note is created it was a bug in our app which is solved...
        self.navigationItem.setHidesBackButton(true, animated: false);
        
        //setting date format
        dateformatter.dateFormat = "MM-dd-yyyy/HH:mm";
        dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle;
        dateformatter.timeStyle = NSDateFormatterStyle.MediumStyle
        date = dateformatter.stringFromDate(todayDate);
    }
    
    func sorting() {
//        print("IN Appear");
        let db:Database = Database();
        db.createDatabase();
        
//        print("OUT \(sortingType)");
        
        if(sortingType == "ascByDate")
        {
//            print("ASCDATE \(sortingType)");
            db.strQuery = "SELECT nid,ntitle,ncontent,cid FROM note_details ORDER BY ndate ASC";
        }
        else if(sortingType == "descByDate")
        {
//            print("DESCDATE \(sortingType)");
            db.strQuery = "SELECT nid,ntitle,ncontent,cid FROM note_details ORDER BY ndate DESC";
        }
        else if(sortingType == "ascByTitle")
        {
//            print("ASCTITLE \(sortingType)");
            db.strQuery = "SELECT nid,ntitle,ncontent,cid FROM note_details ORDER BY ntitle ASC";
        }
        else if(sortingType == "descByTitle")
        {
//           print("DESCTITLE \(sortingType)");
            db.strQuery = "SELECT nid,ntitle,ncontent,cid FROM note_details ORDER BY ntitle DESC";
        }
        else if(sortingType == "default")
        {
//            print("DEFAULT \(sortingType)");
            db.strQuery = "SELECT nid,ntitle,ncontent,cid FROM note_details"
        }

        let temp = db.fetchFromNoteTable()
        nid = temp.id;
        ntitle = temp.ntitle;
        content = temp.content;
        category = temp.category;

        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView?.performBatchUpdates({self.collectionView?.reloadData()}, completion: nil);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ntitle.count;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell;
        
        let cellTitle = cell.viewWithTag(1) as! UILabel;
        cellTitle.text = ntitle[indexPath.row];
        
        let cellContent = cell.viewWithTag(2) as! UILabel;
        cellContent.text = content[indexPath.row];
        
        let cellCategory = cell.viewWithTag(3) as! UILabel;
        cellCategory.text = category[indexPath.row];
        
        let cellId = cell.viewWithTag(4) as! UILabel;
        cellId.text = String(nid[indexPath.row]);
        
        return cell;
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if let cell = collectionView.cellForItemAtIndexPath(indexPath)
        {
            let idLabel = cell.viewWithTag(4) as! UILabel;
            id = Int(idLabel.text!)!;
            print("in click : \(id)");
            
            //segue will change here
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("addNoteVC") as! AddNotesViewController;
            vc.id = id;
            vc.flag = "editNote"
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    @IBAction func addNewNote(sender: UIBarButtonItem) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if(segue.identifier == "addNoteScene")
        {
            let vc = segue.destinationViewController as! AddNotesViewController;
            print("In add");
            vc.flag = "addNote";
        }
    }
    
    @IBAction func sortingFunc(sender: UIBarButtonItem) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("SortVC")
        var controller = vc.popoverPresentationController
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
       vc.preferredContentSize = CGSizeMake(200,200)
        //let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        controller?.barButtonItem = sender
        controller?.delegate = self;
        presentViewController(vc, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }    
}