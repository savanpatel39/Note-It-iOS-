//
//  ImageViewController.swift
//  Testing 2.0
//
//  Created by Savan Patel on 2016-03-07.
//  Copyright © 2016 Savan Patel. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    
    
    @IBOutlet weak var showImage: UIImageView!
    
    var img = UIImage!();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showImage.image = img;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
