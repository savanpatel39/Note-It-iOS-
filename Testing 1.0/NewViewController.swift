//
//  NewViewController.swift
//  Testing 1.2
//
//  Created by Savan Patel on 2016-03-05.
//  Copyright © 2016 Savan Patel. All rights reserved.
//

import UIKit

class NewViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UIPopoverPresentationControllerDelegate,UISearchBarDelegate, UIGestureRecognizerDelegate
{
    
    var nid = [Int]();
    var ntitle = [String]();
    var content = [String]();
    var category = [String]();
    var todayDate : NSDate = NSDate()
    var dateformatter :NSDateFormatter = NSDateFormatter();
    var date : String = "";
    var id = 0;
    var sortingType = "default";
    var searchActive : Bool = false
    var filtered:[String] = []
    
    var filterednid = [Int]();
    var filteredntitle = [String]();
    var filteredcontent = [String]();
    var filteredcategory = [String]();
    
    var tempnid = [Int]();
    var tempntitle = [String]();
    var tempcontent = [String]();
    var tempcategory = [String]();
    
    
    @IBOutlet var myCollectionView: UICollectionView!
    
    @IBOutlet weak var searchBarNotes: UISearchBar!
    
    override func viewWillAppear(animated: Bool) {
        sorting();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false);
        
        //delegate
        searchBarNotes.delegate = self;
        
        dateformatter.dateFormat = "MM-dd-yyyy/HH:mm";
        dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle;
        dateformatter.timeStyle = NSDateFormatterStyle.MediumStyle
        date = dateformatter.stringFromDate(todayDate);
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        longPressGesture.minimumPressDuration = 2.0 // 1 second press
        longPressGesture.delegate = self
        self.myCollectionView.addGestureRecognizer(longPressGesture)
        
    }

    //to handle gesture recognizer
    func handleLongPress(longPressGesture:UILongPressGestureRecognizer)
    {
        
        let p = longPressGesture.locationInView(self.myCollectionView)
        let indexPath = self.myCollectionView.indexPathForItemAtPoint(p)
        
        if indexPath == nil
        {
            print("Long press on table view, not row.")
        }
        else if (longPressGesture.state == UIGestureRecognizerState.Began)
        {
            print("Long press on row, at \(indexPath!.row)")
            
            let myButton: UIButton = UIButton(frame: CGRectMake(125, 2, 25, 25))
            myButton.setTitle("X", forState: .Normal)
            myButton.tag = (indexPath!.row)
            myButton.setImage(UIImage(named: "delete.png"), forState: UIControlState.Normal);
            myButton.addTarget(self, action: Selector("deleteCell:"), forControlEvents: UIControlEvents.TouchUpInside);
//            indexPath.
//            cell.addSubview(myButton)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sorting() {
//        print("IN Appear");
        let db:Database = Database();
        db.createDatabase();
        
        print("OUT \(sortingType)");
        
        if(sortingType == "ascByDate")
        {
            print("ASCDATE \(sortingType)");
            db.strQuery = "SELECT nid,ntitle,ncontent,cname FROM note_details n LEFT JOIN cat_details c ON n.cid=c.cid ORDER BY ndate ASC";
//            db.strQuery = "SELECT nid,ntitle,ncontent,cid FROM note_details ORDER BY ndate ASC";
        }
        else if(sortingType == "descByDate")
        {
            print("DESCDATE \(sortingType)");
            db.strQuery = "SELECT nid,ntitle,ncontent,cname FROM note_details n LEFT JOIN cat_details c ON n.cid=c.cid ORDER BY ndate DESC";
//            db.strQuery = "SELECT nid,ntitle,ncontent,cid FROM note_details ORDER BY ndate DESC";
        }
        else if(sortingType == "ascByTitle")
        {
            print("ASCTITLE \(sortingType)");
            db.strQuery = "SELECT nid,ntitle,ncontent,cname FROM note_details n LEFT JOIN cat_details c ON n.cid=c.cid ORDER BY ntitle ASC";
//            db.strQuery = "SELECT nid,ntitle,ncontent,cid FROM note_details ORDER BY ntitle ASC";
        }
        else if(sortingType == "descByTitle")
        {
            print("DESCTITLE \(sortingType)");
            db.strQuery = "SELECT nid,ntitle,ncontent,cname FROM note_details n LEFT JOIN cat_details c ON n.cid=c.cid ORDER BY ntitle DESC";
//            db.strQuery = "SELECT nid,ntitle,ncontent,cid FROM note_details ORDER BY ntitle DESC";
        }
        else if(sortingType == "default")
        {
            print("DEFAULT \(sortingType)");
            db.strQuery = "SELECT nid,ntitle,ncontent,cname FROM note_details n LEFT JOIN cat_details c ON n.cid=c.cid"
//            db.strQuery = "SELECT nid,ntitle,ncontent,cid FROM note_details"
        }
        
        let temp = db.fetchFromNoteTable()
        
        nid = temp.id;
        ntitle = temp.ntitle;
        content = temp.content;
        category = temp.category;
        
        print("NID : \(nid)");
        
        myCollectionView.reloadData();
        
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive)
        {
            return tempnid.count;
        }
        else
        {
            return ntitle.count;
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! AllNotesCollectionViewCell;
        
        if(searchActive)
        {
            cell.titleLbl.text = tempntitle[indexPath.row];
        
            cell.contentLbl.text = tempcontent[indexPath.row];
        
            cell.categoryLbl.text = tempcategory[indexPath.row];
        
            cell.idLbl.text = String(tempnid[indexPath.row]);
        } 
        else
        {
            cell.titleLbl.text = ntitle[indexPath.row];
        
            cell.contentLbl.text = content[indexPath.row];
        
            cell.categoryLbl.text = category[indexPath.row];
        
            cell.idLbl.text = String(nid[indexPath.row]);
        }
        return cell;
    }

    //to delete cell
    func deleteCell(button: UIButton)
    {
        //        myMutableArray.deleteItemAtIndex(button.tag)
        //        clv.insertItemsAtIndexPaths(button.tag)
        print("deleted idx : \(button.tag)")
        self.myCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
            let indexPaths = self.myCollectionView!.indexPathsForSelectedItems()!;
            let indexPath = indexPaths[0] as NSIndexPath
        
            if(searchActive)
            {
                id = tempnid[indexPath.row];
            }
            else
            {
                id = nid[indexPath.row];
            }
            //segue will change here
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("addNoteVC") as! AddNotesViewController;
            vc.id = id;
            vc.title = ntitle[indexPath.row];
            vc.flag = "editNote"
            self.navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func SortingNames(sender: AnyObject) {
        
        if(sender.tag == 3)
        {
            sortingType = "ascByDate";
        }
        else if(sender.tag == 4)
        {
            sortingType = "descByDate";
        }
        else if(sender.tag == 1)
        {
            sortingType = "ascByTitle";
        }
        else if(sender.tag == 2)
        {
            sortingType = "descByTitle";
        }
        sorting();
    }
    
    
    @IBAction func sortingTapped(sender: UIBarButtonItem) {
        
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
    
    //Searchbar delegate methods
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchData(searchBar);
        print("IN DidBeginEditing");
        //searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchData(searchBar);
        print("IN DidEndEditing");
       // searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
//        self.myCollectionView.reloadData();
//        searchData(searchBar);
        //self.myCollectionView.reloadData();
       // searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("Search CLicked");
        searchData(searchBar);
        //searchActive = false;
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true;
        //        print("Search Entered");
        //data is the aray where actual data will be searched
//        filteredntitle = tempntitle.filter({ (text) -> Bool in
//            let tmp: NSString = text
//            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//            return range.location != NSNotFound
//        });
//
//        filteredcontent = tempcontent.filter({ (text) -> Bool in
//            let tmp: NSString = text
//            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//            return range.location != NSNotFound
//        });
//        
//        if(filtered.count == 0){
//            //searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.myCollectionView.reloadData();
        searchData(searchBar);
    }
    
    func searchData(searchBar : UISearchBar)
    {
        let db = Database();
        db.strQuery = "SELECT nid,ntitle,ncontent,cname FROM note_details n LEFT JOIN cat_details c ON n.cid=c.cid WHERE c.cname LIKE '%\(searchBar.text!)%' OR ncontent LIKE '%\(searchBar.text!)%' OR ntitle LIKE '%\(searchBar.text!)%'";
        
        let temp = db.fetchFromNoteTable();
        
        tempnid = temp.id;
        tempntitle = temp.ntitle;
        tempcontent = temp.content;
        tempcategory = temp.category;
        
        print("\(searchBar.text!)");
        print("Data From Database : \(tempcategory)");
        
        self.myCollectionView.reloadData();
    }
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        let btnSearchCancel = searchBar.valueForKey("cancelButton") as! UIButton
//        btnSearchCancel.setTitle("Cancel", forState: UIControlState.Normal)
//        btnSearchCancel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
//        btnSearchCancel.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Disabled);
//    }
//    
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        self.searchBarNotes.resignFirstResponder();
//        //let db = Database();
//        //db.getNotesBySearch(SQLiteQuery: "SELECT NoteID, NoteTitle, NoteCategoryID, NoteDescription, NoteSoundPath, NoteTime, latitude, longitude FROM Notes WHERE NoteTitle LIKE '%\(searchBar.text!)%' OR NoteDescription LIKE '%\(searchBar.text!)%'");
//    }
    
}
