//
//  AddNotesViewController.swift
//  Testing 1.0
//
//  Created by Savan Patel on 2016-02-19.
//  Copyright © 2016 Savan Patel. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import CoreLocation
import AVFoundation

class AddNotesViewController: UIViewController,UIPopoverPresentationControllerDelegate,CLLocationManagerDelegate, UIImagePickerControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITextViewDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource
{
    let locationManager = CLLocationManager();
    var l: CLLocationCoordinate2D!;
    var location : CLLocation!;
    var catLbl = "Category"
    var con = "Enter note details here..."
    var flag : String = "Any";
    var id = 0;
    var imgCount = 0;
//    var sRecorder: AVAudioRecorder?
//    var sPlayer: AVAudioPlayer?
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    var flagP:Bool = true
    var flagR:Bool = true
    var audioName = "";
    //4 img
    
    var image: UIImage?
    var lastChosenMediaType:String?
    
    var arrImages: [UIImage] = [UIImage]()
    var imgDraw: UIImage!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addTitle: UITextField!
    @IBOutlet weak var addContent: UITextView!
    @IBOutlet weak var img: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var recordBtn: UIBarButtonItem!
    @IBOutlet weak var catBtn: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var audioLbl: UILabel!
    
    
    //to get date from system
    var todayDate : NSDate = NSDate()
    var dateformatter :NSDateFormatter = NSDateFormatter();
    var date : String!// = "";
    var db = Database();
    var address : String = "";
    var tempAddTitle : String!;
    var c = 0;
    var a = 0;
//    var imagePath : [String!];
    var flagImage : Bool = false;
    override func viewWillAppear(animated: Bool) {
        catBtn.setTitle(categoryName, forState: .Normal);
        if(flagImage)
        {
            catLbl = categoryName;
            print("Category Label : \(catLbl)");
        }
//        categoryName = "Category";
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        hideAudioAndVideoComponentes(true);
        
        addTitle.layer.backgroundColor = UIColor.blackColor().CGColor
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        addContent.delegate = self
        
        addContent.text = con
        addContent.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha:
            1.0)
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        catBtn.setTitle(categoryName, forState: .Normal);
        print("From Choose Category : \(categoryName)");
//        categoryName = "Category";
        if (flag == "addNote" || flag == "Any")
        {
            categoryName = "Category";
            print("From Choose Category : \(categoryName)");
            catBtn.setTitle(categoryName, forState: .Normal);
            dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle;
            dateformatter.timeStyle = NSDateFormatterStyle.MediumStyle;
            date = dateformatter.stringFromDate(todayDate);
            dateLabel.text = date;
        }
        else if(flag == "editNote" || flag == "Cat")
        {
            if(flagImage)
            {
                catLbl = categoryName;
                print("Category Label : \(catLbl)");
            }
            loadAllComponents();
        }
        else if(flagImage)
        {
            catBtn.setTitle(catLbl, forState: .Normal);
        }
        
        recordSetup();
        
       // for recording...
//        setupR()
        
//        dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle;
//        dateformatter.timeStyle = NSDateFormatterStyle.MediumStyle;
//        date = dateformatter.stringFromDate(todayDate);
//        dateLabel.text = date;
        
        address = "";
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        appendImage()
        self.imageCollectionView.reloadData();
    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        self.addContent.textColor = UIColor.blackColor()
        
        if(self.addContent.text == con) {
            self.addContent.text = ""
        }
        return true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recTapped(sender: UIBarButtonItem)
    {
        if(flagR == true)
        {
            flagR = false
            
//            sRecorder?.record()
            
            let audioRecordingURL = self.audioRecordingPath()
            do {
                audioRecorder = try AVAudioRecorder(URL: audioRecordingURL, settings: audioRecordingSettings());
                
                guard let recorder = audioRecorder else{
                    return
                }
                recorder.delegate = self;
                recorder.prepareToRecord()
                recorder.record()
                
            } catch {
                audioRecorder = nil;
            }
            
            let sBtn:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "stop.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "recTapped:")
            
            //tb.items?.append(btn)
            toolBar.items?.removeAtIndex(5)
            toolBar.items?.insert(sBtn, atIndex: 5)
            //recordBtn.tintColor = UIColor.blackColor()
            toolBar.tintColor = UIColor.blackColor()
        }
        else
        {
            flagR = true
            
  //          sRecorder?.stop()
            
            self.audioRecorder!.stop()
            
            //show audio player
            self.audioLbl.hidden = false;
            self.playerSlider.hidden = false;
            self.playBtn.hidden = false;
            
            let rBtn:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "record.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "recTapped:")
            
            //tb.items?.append(btn)
            toolBar.items?.removeAtIndex(5)
            toolBar.items?.insert(rBtn, atIndex: 5)
            //            recordBtn.tintColor = UIColor.blackColor()
            toolBar.tintColor = UIColor.blackColor()
        }
    }
    
    //2 play audio
    @IBAction func playTapped(sender: AnyObject)
    {
        do
        {
            let recordedFileData = try NSData(contentsOfURL: audioRecordingPath(), options: NSDataReadingOptions.MappedRead);
            audioPlayer = try AVAudioPlayer(data: recordedFileData);
            
            guard let player = audioPlayer else
            {
                return
            }
            player.delegate = self
            player.prepareToPlay();
            if(flagP == true)
            {
                flagP = false
                playBtn.setImage(UIImage(named: "stop.png"), forState: .Normal)
                player.play();
                var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "aSlider", userInfo: nil, repeats: true)
            }
            else
            {
                flagP = true
                playBtn.setImage(UIImage(named: "play.png"), forState: .Normal)
                player.stop();
            }
            
        }
        catch
        {
            audioPlayer = nil;
        }
    }
    
    //4 slider
    func aSlider()
    {
        let playerTime = Float(audioPlayer!.currentTime * 100.0 / audioPlayer!.duration)
        
        if(playerSlider.value == 99)
        {
            playBtn.setImage(UIImage(named: "play.png"), forState: .Normal)
        }
        playerSlider.value = playerTime
    }
    
    //for audio
    func recordSetup() {
        
        let session = AVAudioSession.sharedInstance();
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker);
            try session.setActive(true);
            session.requestRecordPermission({ (grantedPermission) -> Void in
                print("permission granted : \(grantedPermission)");
            })
        } catch {
            
        }
    }
    
    func audioRecordingPath() -> NSURL{
        let fileManager = NSFileManager()
        let documentsFolderUrl: NSURL?
        do {
            documentsFolderUrl = try fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        } catch _ {
            documentsFolderUrl = nil
        }
        audioName = "note_it_" + addTitle.text!;
        print(documentsFolderUrl!.URLByAppendingPathComponent(audioName))
        return documentsFolderUrl!.URLByAppendingPathComponent(audioName)
        
    }
    
    func audioRecordingSettings() -> [String : AnyObject]{
        return [
            AVFormatIDKey : NSNumber(unsignedInt: kAudioFormatMPEG4AAC),
            AVSampleRateKey : 16000.0 as NSNumber,
            AVNumberOfChannelsKey : 1 as NSNumber,
            AVEncoderAudioQualityKey : AVAudioQuality.Low.rawValue as NSNumber
        ]
    }
    
//    func setupR()
//    {
//        var rSetting : [String : AnyObject] = [ AVFormatIDKey: Int( kAudioFormatAppleIMA4),
//            AVEncoderAudioQualityKey: AVAudioQuality.Max.rawValue,
//            AVEncoderBitRateKey: 320000,
//            AVNumberOfChannelsKey: 2,
//            AVSampleRateKey: 44100.0 ]
//        
//        var error: NSError?
//        
//        do
//        {
//            sRecorder = try AVAudioRecorder(URL: getURL(), settings: rSetting)
//        }
//        catch var error1 as NSError
//        {
//            error = error1
//            sRecorder = nil
//        }
//        if let err = error
//        {
//            NSLog("Something Wrong")
//        }
//        else
//        {
//            sRecorder!.delegate = self
//            sRecorder!.prepareToRecord()
//        }
//    }
    
    func getDir() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        return path[0]
    }
    
    func getURL() -> NSURL
    {
        var rTitle = ""
        if(addTitle.text == "")
        {
            rTitle = "Newnote"
        }
        else
        {
            rTitle = addTitle.text!
        }
        let path = (getDir() as NSString).stringByAppendingPathComponent(rTitle+".m4a")
        let filepath = NSURL(fileURLWithPath: path)
        return filepath
  }
    
    @IBAction func saveNote(sender: UIBarButtonItem)
    {
        let db = Database();
        let lat = String(location.coordinate.latitude);
        let lon = String(location.coordinate.longitude);

        print("Lat : \(lat)");
        print("Long : \(lon)");
        var catid = -1;
        if(catBtn.currentTitle != "Category")
        {
            db.strQuery = "SELECT cid FROM cat_details WHERE cname = '\(catBtn.currentTitle!)'"
            catid = db.getCatId();
        }
        else
        {
            catid = 1;
        }

        //for validation
        var msg = "";
        var msgTitle = "";
//        var altTitle = [String]();
//
//        
        if(addContent.text == "" || addContent.text == "Enter note details here...")
        {
            msgTitle = "Empty Content!";
            msg = "You haven't written anything in content area!";
            let alertActoin = UIAlertController(title: msgTitle, message: msg, preferredStyle: .Alert);
            let okAction = UIAlertAction(title: "Okay", style: .Cancel, handler: nil);
//            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//            
            alertActoin.addAction(okAction);
//            alertActoin.addAction(cancelAction);
            self.presentViewController(alertActoin, animated: true, completion: nil)
        }
        else
        {
            var tempId = 0;
            var isFirst : Bool = false;
            if( self.flag == "addNote" || flag == "Any" )
            {
                db.strQuery = "SELECT nid FROM note_details"
                tempId = db.getCountOfAudioAndVideo() + 1;
                db.strQuery = "INSERT INTO note_details (cid,ntitle,ncontent,ndate,nlatitude,nlongitude) VALUES ('\(catid)','\(addTitle.text!)','\(addContent.text)','\(date)','\(lat)','\(lon)')";
                isFirst = true;
            }
            else if(flag == "editNote" || flag == "Cat")
            {
                isFirst = false;
                tempId = id;
                //            print("In flag Edit");
                db.strQuery = "UPDATE note_details SET cid = '\(catid)',ntitle = '\(addTitle.text!)',ncontent = '\(addContent.text)' WHERE nid = '\(id)'";
            }
            
            db.insertOrUpdateDatabase();
            //segue will change here
            
            //to save images in phone directory
            var c = 0;
            
            db.strQuery = "SELECT npath FROM image_details WHERE nid = '\(tempId)'";
            c = db.getCountOfAudioAndVideo();
            
            if(arrImages.count>0)
            {
                for i in imgCount..<arrImages.count
                {
                    let myImageName = "IMG_\(addTitle.text!)_\(++c).jpg";
                    let imgPath = fileInDocumentsDirectory(myImageName);
                    db.strQuery = "INSERT INTO image_details (nid,npath) VALUES ('\(tempId)','\(myImageName)')";
                    db.saveImagePathToDatabase();
                    //imagePath.append(imgPath);
                    saveImage(arrImages[i], path: imgPath);
                }
            }
            
            if (isFirst)
            {
                db.strQuery = "INSERT INTO audio_details (nid,npath) VALUES ('\(tempId)','\(audioName)')";
                db.saveAudioPathToDatabase();
            }
            else
            {
                db.strQuery = "UPDATE audio_details SET npath = '\(audioName)' WHERE nid = '\(tempId)'";
                db.saveAudioPathToDatabase();
            }
            
            
            //        let NewViewControllerObj = self.storyboard?.instantiateViewControllerWithIdentifier("allNotesVC") as! NewViewController;
            //        self.navigationController?.pushViewController(NewViewControllerObj, animated: true);
            self.navigationController?.popToRootViewControllerAnimated(true);

        }

    }
    
    //2 change icons of imgs
    
    @IBAction func imgBtn(sender: AnyObject)
    {
        
        toolBar.items?.removeAtIndex(0)
        
        let gBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "gallery.png"), style: .Plain, target: self, action: "gal")
        
        let cBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera.png"), style: .Plain, target: self, action: "cam")
        
        toolBar.items?.insert(gBtn, atIndex: 0)
        
        toolBar.items?.removeAtIndex(1)
        toolBar.items?.insert(cBtn, atIndex: 1)
        
//        toolBar.items?.first?.tintColor = UIColor.blackColor()
        toolBar.tintColor = UIColor.blackColor();
        
    }
    
    //2 gallery in img
    
    func gal()
    {
        toolBar.items?.removeAtIndex(0)
        
        let iBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "image.png"), style: .Plain, target: self, action: "imgBtn:")
        
        let pcBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.PageCurl, target: self, action: "")
        toolBar.items?.insert(iBtn, atIndex: 0)
        
        toolBar.items?.removeAtIndex(1)
        toolBar.items?.insert(pcBtn, atIndex: 1)
        
        toolBar.tintColor = UIColor.blackColor()
        
        //let imgPicker:UIImagePickerController = UIImagePickerController()
        
        pickMediaFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
//        imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //imgPicker.delegate = self
        
    }
    
    //4 camera in img
    
    func cam()
    {
        toolBar.items?.removeAtIndex(0)
        
        let iBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "image.png"), style: .Plain, target: self, action: "imgBtn:")
        
        let pcBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.PageCurl, target: self, action: "")
        toolBar.items?.insert(iBtn, atIndex: 0)
        
        toolBar.items?.removeAtIndex(1)
        toolBar.items?.insert(pcBtn, atIndex: 1)
        
        toolBar.tintColor = UIColor.blackColor()
        
        //let imgPicker:UIImagePickerController = UIImagePickerController()
        
        pickMediaFromSource(UIImagePickerControllerSourceType.Camera)
        //imgPicker.sourceType = UIImagePickerControllerSourceType.Camera
        //imgPicker.delegate = self
        
    }
    
    //MARK :4 img
    
    func pickMediaFromSource(sourceType:UIImagePickerControllerSourceType)
    {
        let mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(sourceType)!
        if UIImagePickerController.isSourceTypeAvailable(sourceType) && mediaTypes.count > 0
        {
            let picker = UIImagePickerController()
            picker.mediaTypes = mediaTypes
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            presentViewController(picker, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(
                title:"Error accessing media", message: "Unsupported media source.",
                preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    //4 img
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        flagImage = true;
        lastChosenMediaType = info[UIImagePickerControllerMediaType] as? String
        if let mediaType = lastChosenMediaType
        {
            if mediaType == kUTTypeImage as NSString
                {
                //print("In imagePickerController");
                image = info[UIImagePickerControllerOriginalImage] as? UIImage
                //let img = resizeImageWithSize(image!, size: CGSize(width: 135, height: 135));
                
                arrImages.append(image!);
                self.imageCollectionView.hidden = false;
            }
        }
        if(flagImage)
        {
            self.catBtn.setTitle(catLbl, forState: .Normal);
        }

        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        flagImage = true;
        if(flagImage)
        {
            self.catBtn.setTitle(catLbl, forState: .Normal);
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        picker.dismissViewControllerAnimated(true, completion:nil)
    }
    
    func appendImage(image : UIImage)
    {
        if let mediaType = lastChosenMediaType
        {
            if mediaType == kUTTypeImage as NSString
            {
                arrImages.append(image);
            }
        }
    }
    
    @IBAction func showLocationOnMap(sender: UIBarButtonItem) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MapViewController")

        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        vc.preferredContentSize = CGSizeMake(view.frame.width,view.frame.height/2-50)
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.barButtonItem = sender
        let controller = vc.popoverPresentationController
        controller?.barButtonItem = sender;
        controller?.delegate = self;
        presentViewController(vc, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if(self.flag == "addNote" || flag == "Any")
        {
            location = locations.last;
        
            l = locationManager.location!.coordinate
        
            print("Lat : \(location.coordinate.latitude)");
            print("Lon : \(location.coordinate.longitude)");
            self.locationManager.stopUpdatingLocation()
            setUsersClosestCity();
        }
        else if(self.flag == "editNote")
        {
            setUsersClosestCity()
            self.locationManager.stopUpdatingLocation();
        }
        else if(flag == "Cat")
        {
            self.locationManager.startUpdatingLocation()
            location = locations.last;
            
            l = locationManager.location!.coordinate
            setUsersClosestCity();
            self.locationManager.stopUpdatingLocation();
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "fromAddNoteToMap")
        {
            let mvc = segue.destinationViewController as! MapViewController
            mvc.location = self.l;
        }
        else if(segue.identifier == "addChooseCategoryVC")
        {
            let vc = segue.destinationViewController as! ChooseCategoryViewController
            vc.from = "fromAddNoteVC";
            vc.id = self.id;
            if( flag == "editNote")
            {
                print("Edit Note choose");
            }
        }
        else if(segue.identifier == "imageViewVC")
        {
            
            let indexPaths = self.imageCollectionView!.indexPathsForSelectedItems()!;
            let indexPath = indexPaths[0] as NSIndexPath
            
            let vc = segue.destinationViewController as! ImageViewController
            vc.img = arrImages[indexPath.row];
        }
    }
    
    func setUsersClosestCity()
    {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location)
            {
                (placemarks, error) -> Void in
                
                let placeArray = placemarks as [CLPlacemark]!

                // Place details
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                if let locationName = placeMark.addressDictionary?["Name"] as? String
                {
                    self.address += locationName + ",";
                }
                // City
                if let city = placeMark.addressDictionary?["City"] as? String
                {
                    self.address +=  city + ",";
                }
                // Zip code
                if let zip = placeMark.addressDictionary?["ZIP"] as? String
                {
                    self.address +=  zip + ",";
                }
                if let country = placeMark.addressDictionary?["Country"] as? String
                {
                    self.address += country;
                }
                self.locationLabel.text = self.address;
                self.address = "";
        }
    }
    
    func loadAllComponents()
    {
        let db = Database();
        db.strQuery = "SELECT nid,ntitle,ncontent,cid,ndate,nlatitude,nlongitude FROM note_details WHERE nid = '\(id)'"
        let temp = db.fetchDataForEditVCFromNoteTable(id);
        addTitle.text = temp.ntitle;
        addContent.text = temp.ncontent;
        addContent.textColor = UIColor.blackColor()
        dateLabel.text = temp.ndate;
        self.id = temp.nid;
        location = CLLocation(latitude: temp.nlatitude, longitude: temp.nlongitude);
        l = CLLocationCoordinate2D(latitude: temp.nlatitude, longitude: temp.nlongitude)
        setUsersClosestCity();
        if(flag == "Cat" || flag == "Any")
        {
            catBtn.setTitle(categoryName, forState: .Normal);
        }
        else
        {
            categoryName = temp.ncname;
            catBtn.setTitle(categoryName, forState: .Normal);
        }
        
        db.strQuery = "SELECT npath FROM image_details WHERE nid = '\(id)'";
        c = db.getCountOfAudioAndVideo();
        
        if(c > 0)
        {
            db.strQuery = "SELECT npath FROM image_details WHERE nid = '\(id)'"
            let tempName = db.getImageOrAudioPath();
            //arrImages.removeAll();
            for path in tempName
            {
                let strPath = getDir().stringByAppendingString("/\(path)") //.URLByAppendingPathComponent(path))
                arrImages.append(UIImage(contentsOfFile: strPath)!)
                ;
               // arrImages.append(loadImageFromPath(path)!);
            }
            imgCount = arrImages.count;
            imageCollectionView.hidden = false;
            imageCollectionView.reloadData();
        }
        
        a = db.getCountOfAudioAndVideo();
        if(a > 0)
        {
            db.strQuery = "SELECT npath from audio_details WHERE nid = '\(id)'";
            let tempAudio = db.getImageOrAudioPath();
            audioName = tempAudio[0];
            self.audioLbl.hidden = false;
            self.playerSlider.hidden = false;
            self.playBtn.hidden = false;
        }
    }
    
    func hideAudioAndVideoComponentes(flagH : Bool)
    {
        if(flagH)
        {
            self.audioLbl.hidden = true;
            self.playerSlider.hidden = true;
            self.playBtn.hidden = true;
            self.imageCollectionView.hidden = true;
        }
    }
    
    func resizeImageWithSize(image:UIImage, size:CGSize) -> UIImage {
        var scale:CGFloat = 0;
        
        //    if image.size.width > 250.0 {
        //        scale = 250.0 / image.size.width;
        //    } else if image.size.height > 150.0 {
        //        scale = 150.0 / image.size.height;
        //    }
        
        if image.size.height > size.height
        {
            scale = size.height / image.size.height;
        }
        else if image.size.width > size.height
        {
            scale = size.height / image.size.width;
        }
        else
        {
   
        }
        /// draw image...
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scale, image.size.height * scale))
        image.drawInRect(CGRectMake(0, 0, image.size.width * scale, image.size.height * scale))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage;
    }
    
//    func getDir() -> String
//        {
//            let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//    
//            return path[0]
//        }

    
    //Collection View Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let imagecell = collectionView.dequeueReusableCellWithReuseIdentifier("imagecell", forIndexPath: indexPath) as! ImageCollectionViewCell;
        
        imagecell.imgView.image = arrImages[indexPath.row];
        
// for delete image icon
//        let myButton: UIButton = UIButton(frame: CGRectMake(125, 5, 15, 15))
//        myButton.setTitle("X", forState: .Normal)
//        myButton.tag = (indexPath.row)
//        myButton.setImage(UIImage(named: "delete.png"), forState: UIControlState.Normal);
//        myButton.addTarget(self, action: Selector("deleteCell:"), forControlEvents: UIControlEvents.TouchUpInside);
//        imagecell.addSubview(myButton)
        
        return imagecell;
    }
    
    
    //delete image
    func deleteCell(button: UIButton)
    {
        //        myMutableArray.deleteItemAtIndex(button.tag)
        //        clv.insertItemsAtIndexPaths(button.tag)
        print("deleted idx : \(button.tag)")
        self.imageCollectionView!.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        let indexPaths = self.imageCollectionView!.indexPathsForSelectedItems()!;
//        let indexPath = indexPaths[0] as NSIndexPath
//        
//        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("imageViewVC") as! ImageViewController;
//        vc.img = arrImages[indexPath.row];
//        //            vc.title = ntitle[id];
//
//        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    
    
    //get path for images // do not use it
    func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        
        return documentsURL
    }
    
    func fileInDocumentsDirectory(filename: String) -> NSURL {
        
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL
    }
    
    
    //for saving and loading images
    func saveImage (image: UIImage, path: NSURL ) -> Bool{
        
//        let pngImageData = UIImagePNGRepresentation(image)
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = jpgImageData!.writeToURL(path, atomically: true)
        
        return result
        
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        print("path : \(path)");
        if image == nil {
            
            print("missing image at: \(path)")
        }
        else
        {
            print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        }
        return image
    }
    
    //MARK: audio
    
}