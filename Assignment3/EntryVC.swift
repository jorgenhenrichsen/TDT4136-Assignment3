//
//  EntryVC.swift
//  Assignment3
//
//  Created by Tord Åsnes on 30/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import UIKit

class EntryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let pathFindingButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width/2, height: view.bounds.height))
        pathFindingButton.addTarget(self, action: #selector(showPathFinderVC), for: .touchUpInside)
        pathFindingButton.setTitle("Pathfinding", for: .normal)
        pathFindingButton.setTitleColor(.black, for: .normal)
        view.addSubview(pathFindingButton)
        
        let rushHourButton = UIButton(frame: CGRect(x: view.bounds.width/2, y: 0, width: view.bounds.width/2, height: view.bounds.height))
        rushHourButton.addTarget(self, action: #selector(showRushHourVC), for: .touchUpInside)
        rushHourButton.setTitle("Rush Hour", for: .normal)
        rushHourButton.setTitleColor(.black, for: .normal)
        view.addSubview(rushHourButton)
        
    }
    
    func showPathFinderVC() {
        let pathFinderVC = PathFinderVC()
        present(pathFinderVC, animated: true, completion: nil)
    }
    
    func showRushHourVC() {
        let rushHourVC = RushHourVC()
        present(rushHourVC, animated: true, completion: nil)
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
