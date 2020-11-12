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
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        
        let lavaNode = createLava()
        self.sceneView.scene.rootNode.addChildNode(lavaNode)
        // Do any additional setup after loading the view.
    }
    
    func createLava() -> SCNNode{
        let lavaNode = SCNNode(geometry: SCNPlane(width: 1, height: 1))
        lavaNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "lava")
        lavaNode.position = SCNVector3(0,0,-1)
        
        return lavaNode
    }

    //é chamado quando um novo plano horizontal é detectado
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        print("new flat surface detected, new ARPlaneAnchor added")
    }
    
    //é chamado quando um plano é mudado - tamanho
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        print("updationg floor anchor")
    }
    // é chamado quando é criado mais de um anchor pro mesmo plano, é nesse momento que ele remove um deles e a ambiguidade é cancelada
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("I made a mistake, and I am fixing it...")
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}

