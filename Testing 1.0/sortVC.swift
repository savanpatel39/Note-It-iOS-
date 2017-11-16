//
//  sortVC.swift
//  Testing 1.2
//
//  Created by Savan Patel on 2016-03-02.
//  Copyright © 2016 Savan Patel. All rights reserved.
//

import UIKit

class sortVC: UIViewController,UIPopoverPresentationControllerDelegate
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnTapped(sender: UIButton)
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("newAllNotesVC")
            as! NewViewController;
        if(sender.tag == 1)
        {
            //print("tag1");
            vc.sortingType = "ascByTitle";
            print("\(vc.sortingType)");
        }
        else if(sender.tag == 2)
        {
            //print("tag2");
            vc.sortingType = "descByTitle";
            print("\(vc.sortingType)");
            
        }
        else if(sender.tag == 3)
        {
            //print("tag3");
            vc.sortingType = "ascByDate";
            print("\(vc.sortingType)");
            
        }
        else if(sender.tag == 4)
        {
            //print("tag4");
            vc.sortingType = "descByDate";
            print("\(vc.sortingType)");
        }
        else
        {
            vc.sortingType = "default";
            print("\(vc.sortingType)");
        }
        self.dismissViewControllerAnimated(true, completion: {()->Void in
            vc.sorting();
            //vc.collectionView?.reloadData();
            self.navigationController?.pushViewController(vc, animated: true);
            //vc.collectionView?.reloadData();
//            vc.myCollectionView.reloadData();
        });

        //
        //self.navigationController?.pushViewController(vc, animated: true);
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
//    {
//        if(sender?.backgroundImage == UIImage(named: "a-z.png"))
//        {
//            print("A-Z")
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
