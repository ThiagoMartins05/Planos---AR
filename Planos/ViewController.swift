//
//  ViewController.swift
//  Planos
//
//  Created by Thiago Martins on 12/11/20.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
       // self.configuration.planeDetection = [.horizontal, .vertical] // permite detectar planos horizontais e verticasi
        self.configuration.planeDetection = [.horizontal]
        self.sceneView.session.run(configuration)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func add(_ sender: Any) {
        self.sceneView.delegate = self
        
    }
    @IBAction func remove(_ sender: Any) {
        self.sceneView.delegate = nil
    }
    
    func createLava(planeAnchor: ARPlaneAnchor) -> SCNNode{
        let lavaNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        lavaNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "lava")
        lavaNode.geometry?.firstMaterial?.isDoubleSided = true
        lavaNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        lavaNode.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
        return lavaNode
    }

    //é chamado quando um novo plano horizontal é detectado
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
      //  print("new flat surface detected, new ARPlaneAnchor added")
        
        if planeAnchor.alignment == .horizontal{
            print("horizontal")
        }
        if planeAnchor.alignment == .vertical{
            print("vertical")
        }
        let lavaNode = createLava(planeAnchor: planeAnchor)
        node.addChildNode(lavaNode)
    }
    
    //é chamado quando um plano é mudado - tamanho
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
            
        }
        
        let lavaNode = createLava(planeAnchor: planeAnchor)
        node.addChildNode(lavaNode)
        print("updationg floor anchor")
    }
    // é chamado quando é criado mais de um anchor pro mesmo plano, é nesse momento que ele remove um deles e a ambiguidade é cancelada
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("I made a mistake, and I am fixing it...")
        
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
            
        }
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}

