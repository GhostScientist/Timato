//
//  LaunchViewController.swift
//  Timato
//
//  Created by Dakota Kim on 5/27/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import UIKit
import ChameleonFramework

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var launchImageOutlet: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.flatRed
        launchImageOutlet.image = UIImage(named: "tomato.png")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
