//
//  SplachViewController.swift
//  Sparzel
//
//  Created by Artem Misesin on 1/21/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class SplachViewController: UIViewController {
    
    @IBOutlet weak var roundedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedView.layer.cornerRadius = 8
            // Show the home screen after a bit. Calls the show() function.
        _ = Timer.scheduledTimer(
            timeInterval: 1, target: self, selector: #selector(showVC), userInfo: nil, repeats: false
            )
        }

        func showVC() {
            let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "main") as! ViewController
            
            present(vc, animated: true, completion: nil)
        }
}
