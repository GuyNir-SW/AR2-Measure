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

    // Widgets
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    
    
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
        // AR Gestures
        //------------------------------------
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        //------------------------------------
        // Make sure required widgets are at front
        //------------------------------------
        
        //view.bringSubviewToFront(...)
        
    }
    
    //------------------------------
    //MARK: AR Gesture methods
    //------------------------------
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else {return}
        
        // Get current frame, in order to tell orientation of camera
        guard let currentFrame = sceneView.session.currentFrame else {return}
        let camera = currentFrame.camera
        let transform = camera.transform
        
        // Calculate the location that will be infront of the camera (not sure this is right calculation)
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.z = -0.1
        var modifiedMatrix = simd_mul(transform, translationMatrix)
        
        // Create a small sphere infront of the camera
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.005))
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        sphere.simdTransform = modifiedMatrix
        self.sceneView.scene.rootNode.addChildNode(sphere)
    }
    
    //------------------------------
    //MARK: Additional methods
    //------------------------------
    
    


}
