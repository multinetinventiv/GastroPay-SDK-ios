***REMOVED***
***REMOVED***  SelectEnvironmentViewController.swift
***REMOVED***  FrameworkTest
***REMOVED***
***REMOVED***  Created by ilker sevim on 4.03.2021.
***REMOVED***  Copyright © 2021 multinet. All rights reserved.
***REMOVED***

import UIKit
import Gastropay

class SelectEnvironmentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        ***REMOVED*** Do any additional setup after loading the view.
    }
    
    func openOtherScreen(apiType:APIType){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTestViewController") as! ViewController
        
        vc.lastSelectedApiType = apiType
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func useDevEnvironmentClicked(_ sender: Any) {
        openOtherScreen(apiType: .dev)
    }
    @IBAction func useTestEnvironmentClicked(_ sender: Any) {
        openOtherScreen(apiType: .test)
    }
    @IBAction func usePilotEnvClicked(_ sender: Any) {
        openOtherScreen(apiType: .pilot)
    }
    @IBAction func useProdEnvClicked(_ sender: Any) {
        openOtherScreen(apiType: .prod)
    }

}
