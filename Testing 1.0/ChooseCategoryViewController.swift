//
//  ChooseCategoryViewController.swift
//  Testing 1.0
//
//  Created by Savan Patel on 2016-02-23.
//  Copyright © 2016 Savan Patel. All rights reserved.
//

import UIKit

class ChooseCategoryViewController: UICollectionViewController {

    var Array = [String]();
    var catname : String!;
    var from : String!;
    var id = 0;
    var flag:String!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Database();
        db.strQuery = "SELECT cname from cat_details";
        Array = db.fetchFromCategotyTable();
        //Array = ["Default","Personal","Education","Work","Shopping"];
        //Loda aa te view did load ma krayu 6...to every time aa j values aawse...ema add krwa nu sodhje...I know aapde db ma store krawi daisu...bt to b...
        Array.append("+");
        
        // Do any additional setup after loading the view.
        
        //to change color of text in nav bar
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Array.count;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let categoryCell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath) as UICollectionViewCell;
        
        let cellButton = categoryCell.viewWithTag(1) as! UIButton;
        
        cellButton.setTitle(Array[indexPath.row], forState: .Normal);
        
        return categoryCell;
    }
    
    
    @IBAction func addCategory(sender: UIButton)
    {
        catname = sender.currentTitle;
        if( catname == "+")
        {
            //code to add alert controller with text field ;)
            catname = sender.currentTitle;
        }
        else
        {
            print("Name : \(catname)");
        }
        
//        prepareForSegue(nil, sender: nil);
        transitionBack();
    }
    func transitionBack() {
        if(catname != "+")
        {
//            if(segue.identifier == "fromChooseCategoryToAddNotes")
//            {
            let vc:AddNotesViewController = self.storyboard?.instantiateViewControllerWithIdentifier("addNoteVC") as! AddNotesViewController
                vc.catLbl = catname;
                vc.flag = "Cat";
                //vc.catBtn.setTitle(catname, forState: .Normal)
                vc.id = self.id;
            categoryName = catname;
            self.navigationController?.popViewControllerAnimated(true);
                //print("In choose cate : \(vc.flag)");
//            }
        }
        else
        {
            let alert = UIAlertController(title: "App Name", message: "New Category", preferredStyle: .Alert)
            
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                //            textField.text = "Some default text."
                textField.placeholder = "Enter New Category Name..."
            })
            
            var t = 0;
            let createAction = UIAlertAction(title: "Create", style: .Default, handler:
                {
                    (action) -> Void in let textField = alert.textFields![0]
                    //print("Text field: \(textField.text)")
                    //new category will be inserted here and from database category will be shown here
                    if(textField.text! != "")
                    {
                        
                        let db = Database();
                        db.strQuery = "INSERT INTO cat_details (cname) VALUES ('\(textField.text!)')";
                        db.insertOrUpdateDatabase();
                        self.Array.insert(textField.text!, atIndex: self.Array.count-1);
                        self.Array.removeAll();
                        
                        db.strQuery = "SELECT cname from cat_details";
                        self.Array = db.fetchFromCategotyTable();
                        self.Array.append("+")
                        self.collectionView?.reloadData();
                    }
                    else
                    {
                        //t = 1
                    }
            })
//            createAction.enabled = false;
            
            //            if(t == 1)
            //            {
            //                createAction.enabled = false;
            //            }
            //            else
            //            {
            //                createAction.enabled = true;
            //            }
            //            alert.addAction(UIAlertAction(title: "Create", style: .Default, handler:
            //                {
            //                    (action) -> Void in let textField = alert.textFields![0]
            //                    //print("Text field: \(textField.text)")
            //                    //new category will be inserted here and from database category will be shown here
            //                    if(textField.text! != "")
            //                    {
            //                        let db = Database();
            //                        db.strQuery = "INSERT INTO cat_details (cname) VALUES ('\(textField.text!)')";
            //                        db.insertOrUpdateDatabase();
            //                        self.Array.insert(textField.text!, atIndex: self.Array.count-1);
            //                        self.Array.removeAll();
            //
            //                        db.strQuery = "SELECT cname from cat_details";
            //                        self.Array = db.fetchFromCategotyTable();
            //                        self.Array.append("+")
            //                        self.collectionView?.reloadData();
            //                    }
            //            }))
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            alert.addAction(createAction)
            alert.view.tintColor = UIColor.blackColor()
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(catname != "+")
        {
        if(segue.identifier == "fromChooseCategoryToAddNotes")
            {
                let vc = segue.destinationViewController as! AddNotesViewController
                vc.catLbl = catname;
                vc.flag = "Cat";
                categoryName = catname;
//                vc.id = self.id;
                print("In choose cate : \(vc.flag)");
            }
        }
        else
        {
            let alert = UIAlertController(title: "App Name", message: "New Category", preferredStyle: .Alert)
            
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                //            textField.text = "Some default text."
                textField.placeholder = "Enter New Category Name..."
            })
            
            var t = 0;
            let createAction = UIAlertAction(title: "Create", style: .Default, handler:
                {
                    (action) -> Void in let textField = alert.textFields![0]
                    //print("Text field: \(textField.text)")
                    //new category will be inserted here and from database category will be shown here
                    if(textField.text! != "")
                    {
                        
                        let db = Database();
                        db.strQuery = "INSERT INTO cat_details (cname) VALUES ('\(textField.text!)')";
                        db.insertOrUpdateDatabase();
                        self.Array.insert(textField.text!, atIndex: self.Array.count-1);
                        self.Array.removeAll();
                        
                        db.strQuery = "SELECT cname from cat_details";
                        self.Array = db.fetchFromCategotyTable();
                        self.Array.append("+")
                        self.collectionView?.reloadData();
                    }
                    else
                    {
                        //t = 1
                    }
            })
            createAction.enabled = false;
            
//            if(t == 1)
//            {
//                createAction.enabled = false;
//            }
//            else
//            {
//                createAction.enabled = true;
//            }
//            alert.addAction(UIAlertAction(title: "Create", style: .Default, handler:
//                {
//                    (action) -> Void in let textField = alert.textFields![0]
//                    //print("Text field: \(textField.text)")
//                    //new category will be inserted here and from database category will be shown here
//                    if(textField.text! != "")
//                    {
//                        let db = Database();
//                        db.strQuery = "INSERT INTO cat_details (cname) VALUES ('\(textField.text!)')";
//                        db.insertOrUpdateDatabase();
//                        self.Array.insert(textField.text!, atIndex: self.Array.count-1);
//                        self.Array.removeAll();
//                        
//                        db.strQuery = "SELECT cname from cat_details";
//                        self.Array = db.fetchFromCategotyTable();
//                        self.Array.append("+")
//                        self.collectionView?.reloadData();
//                    }
//            }))
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            alert.addAction(createAction)
            alert.view.tintColor = UIColor.blackColor()
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
