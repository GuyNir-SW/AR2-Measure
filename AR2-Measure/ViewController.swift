//
//  ViewController.swift
//  AR2-Measure
//
//  Created by Guy Nir on 12/10/2019.
//  Copyright © 2019 Guy Nir. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    //------------------------------
    //MARK: Properties
    //------------------------------
    
    // AR basic stuff
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()

    
    
    //MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //------------------------------------
        // AR basic stuff
        //------------------------------------
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Debug options
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
                                       ARSCNDebugOptions.showWorldOrigin]
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Detect planes
        //self.configuration.planeDetection = .horizontal
        
        // Run the scene
        sceneView.session.run(configuration)
        
        //------------------------------------
        // Make sure required widgets are at front
        //------------------------------------
        
        //view.bringSubviewToFront(...)
        
    }
    
    
    
    //MARK: Additional methods
    


}
