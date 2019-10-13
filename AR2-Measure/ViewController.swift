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
    
    // Various AR objects
    var startingPosition : SCNNode?
    
    
    
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
        
        /*
        // Calculate the location that will be infront of the camera (not sure this is right calculation)
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.z = -0.1
        var modifiedMatrix = simd_mul(transform, translationMatrix)
        */
        
        // Create a small sphere infront of the camera
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.005))
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        sphere.simdTransform = transform
        print ("DEBUG: Before adding child")
        self.sceneView.scene.rootNode.addChildNode(sphere)
        print ("DEBUG: After adding child")
        self.startingPosition = sphere
    }
    
    //------------------------------
    //MARK: AR Renderer methods
    //------------------------------
    
    // This is called at constant intervals
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        // Check whether we have a starting position
        guard let startingPosition = self.startingPosition else { return }
        
        print ("DEBUG: Started Update At time")
        // Get current position
        let pos = getCurrOrientation(distanceFromCamera: 0)
        
        // Calc x,y,z distances
        let xDist = pos.x - startingPosition.position.x
        let yDist = pos.y - startingPosition.position.y
        let zDist = pos.z - startingPosition.position.z
        
        let dist = pos.distance(vector: startingPosition.position)
        
        // Set labels, this has to be dispatached to main queue
        DispatchQueue.main.async {
            self.distanceLabel.text = String(format: "%.2f", dist)
            self.xLabel.text = String(format: "%.2f", xDist)
            self.yLabel.text = String(format: "%.2f", yDist)
            self.zLabel.text = String(format: "%.2f", zDist)
        }
        
    }
    
    
    //------------------------------
    //MARK: Additional methods
    //------------------------------
    
    /*
     * This methods returns a point that is located right in front of the camera
     * at a distance which is "distanceFromCamera"
     */
    func getCurrOrientation (distanceFromCamera : Float) -> SCNVector3 {
        guard let pointOfView = self.sceneView.pointOfView else {
            print ("Error: could not get Point Of View")
            let invalid = SCNVector3(0, 0, 0)
            return invalid
        }
        
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        
        // Normalize the orientation and set it to the desired distance
        var desiredOrientation = orientation.normalized()
        desiredOrientation *= distanceFromCamera
        
        // Final point is location added with orientation
        let pointInFrontOfCamera = location + desiredOrientation
        
        // Debug print
        print ("location: \(location.x), \(location.y), \(location.z)" )
        print ("orientation: \(orientation.x), \(orientation.y), \(orientation.z)" )
        print ("Camera: \(pointInFrontOfCamera.x), \(pointInFrontOfCamera.y), \(pointInFrontOfCamera.z)" )
            
        // Return desired value
        return pointInFrontOfCamera
    }
    


}
