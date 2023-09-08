//
//  DenemeViewController.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 31.07.2023.
//

import UIKit

class DenemeViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container1.isHidden = true
        container2.isHidden = true

        // Do any additional setup after loading the view.
        
    }
    var whichPage = 0
    @IBAction func swipeLeft(_ sender: Any) {
        if(whichPage > 0){
            segmentControl.selectedSegmentIndex =
            segmentControl.selectedSegmentIndex - 1
        }else{
            segmentControl.selectedSegmentIndex = 3
            print("you already reach the end of the left")
        }
        
      
        merhabalar(sender)
    }
    @IBAction func swipeGestureRight(_ sender: Any) {
        if(segmentControl.numberOfSegments > (whichPage+1)){
            segmentControl.selectedSegmentIndex =
            segmentControl.selectedSegmentIndex + 1
        }else{
            segmentControl.selectedSegmentIndex = 0
            print("you already reach the end")
        }
        
      
        merhabalar(sender)
        
    }
    @IBOutlet weak var container1: UIView!
    @IBOutlet weak var container2: UIView!
    
    @IBAction func merhabalar(_ sender: Any) {
        container1.isHidden = true
        container2.isHidden = true
        switch segmentControl.selectedSegmentIndex{
        case 0:
            container1.isHidden = false
            self.view.backgroundColor = .systemRed
            whichPage = 0
            break
        case 1:
            container2.isHidden = false
            self.view.backgroundColor =  .systemBlue
            whichPage = 1
            break
        case 2:
            container1.isHidden = false
            self.view.backgroundColor = .systemRed
            whichPage = 2
            break
        case 3:
            container2.isHidden = false
            self.view.backgroundColor =  .systemBlue
            whichPage = 3
            break
            
        default:
            whichPage = -1
            break
        }
        
        
    }
    @IBAction func blabla(_ sender: Any) {
     
        
    }
    
}

class deneme2:UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    

    
}
