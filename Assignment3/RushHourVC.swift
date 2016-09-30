//
//  RushHourVC.swift
//  Assignment3
//
//  Created by Tord Åsnes on 30/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import UIKit

class RushHourVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
