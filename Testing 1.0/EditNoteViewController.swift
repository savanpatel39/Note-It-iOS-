//
//  EditNoteViewController.swift
//  Testing 1.0
//
//  Created by Savan Patel on 2016-02-22.
//  Copyright © 2016 Savan Patel. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController,UIPopoverPresentationControllerDelegate
{
    
    @IBOutlet weak var addTitle: UITextField!
    @IBOutlet weak var recordBtn: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imgBtn: UIBarButtonItem!
    @IBOutlet weak var addContent: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var catBtn: UIButton!
    
    var flagR:Bool = true
    var id = -1;
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        addContent.layer.backgroundColor = UIColor.blackColor().CGColor
        
        //to change color of text in nav bar
  //      self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recTapped(sender: UIBarButtonItem)
    {
        if( flagR == true)
        {
            flagR = false
            
            let btn:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "stop.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "recTapped:")
            
            //tb.items?.append(btn)
            toolBar.items?.removeAtIndex(5)
            toolBar.items?.insert(btn, atIndex: 5)
            //recordBtn.tintColor = UIColor.blackColor()
            toolBar.items?.last?.tintColor = UIColor.blackColor()
        }
        else
        {
            flagR = true
            
            let btn:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "record.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "recTapped:")
            
            //tb.items?.append(btn)
            toolBar.items?.removeAtIndex(5)
            toolBar.items?.insert(btn, atIndex: 5)
//            recordBtn.tintColor = UIColor.blackColor()
            toolBar.items?.last?.tintColor = UIColor.blackColor()
        }
    }

    @IBAction func imgBtn(sender: AnyObject)
    {
        
        toolBar.items?.removeAtIndex(0)
        
        let gBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "gallery.png"), style: .Plain, target: self, action: "gal")
        
        let cBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera.png"), style: .Plain, target: self, action: "cam")
        
        toolBar.items?.insert(gBtn, atIndex: 0)
        
        toolBar.items?.removeAtIndex(1)
        toolBar.items?.insert(cBtn, atIndex: 1)
        
        toolBar.tintColor = UIColor.blackColor();

    }
    
    func gal()
    {
        toolBar.items?.removeAtIndex(0)
        
        let iBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "image.png"), style: .Plain, target: self, action: "imgBtn:")
        
        let pcBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.PageCurl, target: self, action: "")
        toolBar.items?.insert(iBtn, atIndex: 0)
        
        toolBar.items?.removeAtIndex(1)
        toolBar.items?.insert(pcBtn, atIndex: 1)
        
        toolBar.tintColor = UIColor.blackColor();
    }
    
    func cam()
    {
        toolBar.items?.removeAtIndex(0)
        
        let iBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "image.png"), style: .Plain, target: self, action: "imgBtn:")
        
        let pcBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.PageCurl, target: self, action: "")
        toolBar.items?.insert(iBtn, atIndex: 0)
        
        toolBar.items?.removeAtIndex(1)
        toolBar.items?.insert(pcBtn, atIndex: 1)
        
        toolBar.tintColor = UIColor.blackColor();
    }
    
    @IBAction func saveEditedNote(sender: UIBarButtonItem) {
        
        let MainViewControllerObj = self.storyboard?.instantiateViewControllerWithIdentifier("allNotesVC") as! MainViewController;
        self.navigationController?.pushViewController(MainViewControllerObj, animated: true);
    }
    
    
    @IBAction func showLocationOnMap(sender: UIBarButtonItem) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MapViewController")
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        vc.preferredContentSize = CGSizeMake(view.frame.width,view.frame.height/2-50)
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.barButtonItem = sender
        let controller = vc.popoverPresentationController
        controller?.delegate = self;
        presentViewController(vc, animated: true, completion:nil)
    }

    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "fromEditNoteToMap")
        {
            print("\n\n\n\nIn prepare for segue");
     //       let mvc = segue.destinationViewController as! MapViewController
            //mvc.location = CLLocationCoordinate2D(latitude: self.l.latitude,longitude: self.l.longitude);
       //     mvc.location = self.l;
        }
        else if(segue.identifier == "editChooseCategoryVC")
        {
            let vc = segue.destinationViewController as! ChooseCategoryViewController
            vc.from = "fromEditNoteVC";
        }

        //mvc.location.latitude = self.l.latitude;
        //mvc.location.longitude = ;
        //mvc.showAnnotationOnMap(mvc.location);
    }
}
