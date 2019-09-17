//
//  GameViewController.swift
//  MazeGame
//
//  Created by Daniel Lambert, Josh Ryan, Leo Stelmaszek on 2/26/18.
//  Copyright © 2018 Bootleg Mobile. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController{
    
    var sceneView: SCNView!
    var camera = SCNNode()
    var cameraOrbit = SCNNode()
    var ground = SCNNode()
    var light = SCNNode()
    var constraint = SCNLookAtConstraint()
    
    let sW = UIScreen.main.bounds.width         //screen width
    let sH = UIScreen.main.bounds.height        //screen height
    
    //objects to be added to scene
    var lookAtNode = SCNNode()
    var wall: [SCNNode] = []
    let materialRed = SCNMaterial()                 //set red material
    let materialCyan = SCNMaterial()                //set cyan material
    
//
//    var testMaze = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
//                    [1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1],
//                    [1,0,1,1,1,1,1,1,0,1,0,1,0,1,0,1],
//                    [1,0,1,0,0,0,1,0,0,1,0,0,0,1,0,1],
//                    [1,0,1,0,1,0,1,0,1,1,1,1,1,1,0,1],
//                    [1,0,0,0,1,0,1,0,0,0,0,0,0,1,0,1],
//                    [1,1,1,1,1,0,1,1,1,1,1,1,0,1,0,1],
//                    [0,0,1,0,0,0,0,0,0,0,1,0,0,1,0,1],
//                    [1,0,1,1,1,1,1,1,1,0,1,0,0,0,0,1],
//                    [1,0,1,0,0,0,0,0,1,0,1,0,1,1,0,1],
//                    [1,0,1,0,1,1,1,0,1,0,1,0,1,1,0,1],
//                    [1,0,0,0,1,0,1,0,1,1,1,0,1,1,0,1],
//                    [1,1,1,1,1,0,1,0,1,1,1,0,1,1,0,1],
//                    [1,0,0,0,0,0,1,0,0,0,1,0,0,1,0,1],
//                    [1,0,1,1,1,1,1,1,1,0,1,1,0,1,0,1],
//                    [1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0],
//                    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]
    
    //         8x8 array with walls
    var testMaze = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]
    
    //        8x8 array
    var gridTemplate = [0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0]
    
    var gameView: SCNView!
    var gameScene: SCNScene!
    var camaraNode: SCNNode!
    var targetCreationTime: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initMaterial()
        initElements()
        //generateMaze()
        //loadMaze()
        
        //Left Button
        LeftButton.setTitle("<", for: .normal)
        LeftButton.setTitleColor(UIColor.white, for: .normal)
        LeftButton.frame = CGRect(origin: CGPoint(x: sW*(1/8)-25,y :sH-100), size: CGSize(width: 50, height: 50))
        LeftButton.transform = CGAffineTransform(scaleX: 3,y: 3);
        LeftButton.addTarget(self, action:#selector(leftButton), for: .touchUpInside)
        
        //Right Button
        RightButton.setTitle(">", for: .normal)
        RightButton.setTitleColor(UIColor.white, for: .normal)
        RightButton.frame = CGRect(origin: CGPoint(x: sW*(7/8)-25,y :sH-100), size: CGSize(width: 50, height:50))
        RightButton.transform = CGAffineTransform(scaleX: 3,y: 3);
        RightButton.addTarget(self, action:#selector(rightButton), for: .touchUpInside)
        
        //Forward Button
        ForwardButton.setTitle("^", for: .normal)
        ForwardButton.setTitleColor(UIColor.white, for: .normal)
        ForwardButton.frame = CGRect(origin: CGPoint(x: sW*(1/2)-25,y :sH-100), size: CGSize(width: 50, height: 50))
        ForwardButton.transform = CGAffineTransform(scaleX: 4,y: 4);
        ForwardButton.addTarget(self, action:#selector(forwardButton), for: .touchUpInside)
        
        
        //Pause Menu
        PauseMenu.setTitle("Menu", for: .normal)
        PauseMenu.setTitleColor(UIColor.black, for: .normal)
        PauseMenu.frame = CGRect(origin: CGPoint(x: 0,y :15), size: CGSize(width: 100, height: 30))
        PauseMenu.addTarget(self, action:#selector(pauseMenu), for: .touchUpInside)
        
        //Pause Menu Reset Button
        PauseReset.setTitle("Reset", for: .normal)
        PauseReset.setTitleColor(UIColor.black, for: .normal)
        PauseReset.frame = CGRect(origin: CGPoint(x: sW*(0.5)-(145/2),y :sH*(1/8)), size: CGSize(width: 145, height: 50))
        PauseReset.transform = CGAffineTransform(scaleX: 3,y: 3);
        PauseReset.addTarget(self, action:#selector(pauseResetMenu), for: .touchUpInside)
        
        //Pause Menu Restart Button
        PauseRestart.setTitle("Restart", for: .normal)
        PauseRestart.setTitleColor(UIColor.black, for: .normal)
        PauseRestart.frame = CGRect(origin: CGPoint(x: sW*(0.5)-(145/2),y :sH*(3/8)), size: CGSize(width: 145, height: 50))
        PauseRestart.transform = CGAffineTransform(scaleX: 3,y: 3);
        PauseRestart.addTarget(self, action:#selector(pauseRestartMenu), for: .touchUpInside)
        
        //Pause Menu to Main Menu Button
        PauseMainMenu.setTitle("Main Menu", for: .normal)
        PauseMainMenu.setTitleColor(UIColor.black, for: .normal)
        PauseMainMenu.frame = CGRect(origin: CGPoint(x: sW*(0.5)-(145/2),y :sH*(5/8)), size: CGSize(width: 145, height: 50))
        PauseMainMenu.transform = CGAffineTransform(scaleX: 3,y: 3);
        PauseMainMenu.addTarget(self, action:#selector(pauseMainMenu), for: .touchUpInside)
        
        //Pause Menu back to Maze
        BackToMaze.setTitle("Back", for: .normal)
        BackToMaze.setTitleColor(UIColor.black, for: .normal)
        BackToMaze.frame = CGRect(origin: CGPoint(x: sW*(0.5)-(145/2),y :sH*(7/8)), size: CGSize(width: 145, height: 50))
        BackToMaze.transform = CGAffineTransform(scaleX: 3,y: 3);
        BackToMaze.addTarget(self, action:#selector(backToMaze), for: .touchUpInside)
        
        //Confrim Restart
        ConfirmRestartButton.setTitle("Yes", for: .normal)
        ConfirmRestartButton.setTitleColor(UIColor.white, for: .normal)
        ConfirmRestartButton.frame = CGRect(origin: CGPoint(x: sW*(2/8)-25,y :sH-200), size: CGSize(width: 50, height: 50))
        ConfirmRestartButton.transform = CGAffineTransform(scaleX: 4,y: 4);
        ConfirmRestartButton.addTarget(self, action:#selector(restart), for: .touchUpInside)
        
        //Deny Restart
        DenyRestartButton.setTitle("No", for: .normal)
        DenyRestartButton.setTitleColor(UIColor.white, for: .normal)
        DenyRestartButton.frame = CGRect(origin: CGPoint(x: sW*(6/8)-25,y :sH-200), size: CGSize(width: 50, height: 50))
        DenyRestartButton.transform = CGAffineTransform(scaleX: 4,y: 4);
        DenyRestartButton.addTarget(self, action:#selector(deny), for: .touchUpInside)
        
        //Restart Message
        RestartMessage.numberOfLines = 4
        RestartMessage.text = "Are you sure you want to restart? \n(Restart current maze)"
        RestartMessage.frame = CGRect(origin: CGPoint(x: sW*(0.5)-50,y :sH*(1/8)), size: CGSize(width: 145, height: 100))
        RestartMessage.transform = CGAffineTransform(scaleX: 2,y: 2);
        
        //Confrim Reset
        ConfirmResetButton.setTitle("Yes", for: .normal)
        ConfirmResetButton.setTitleColor(UIColor.white, for: .normal)
        ConfirmResetButton.frame = CGRect(origin: CGPoint(x: sW*(2/8)-25,y :sH-200), size: CGSize(width: 50, height: 50))
        ConfirmResetButton.transform = CGAffineTransform(scaleX: 4,y: 4);
        ConfirmResetButton.addTarget(self, action:#selector(reset), for: .touchUpInside)
        
        //Deny Restart
        DenyResetButton.setTitle("No", for: .normal)
        DenyResetButton.setTitleColor(UIColor.white, for: .normal)
        DenyResetButton.frame = CGRect(origin: CGPoint(x: sW*(6/8)-25,y :sH-200), size: CGSize(width: 50, height: 50))
        DenyResetButton.transform = CGAffineTransform(scaleX: 4,y: 4);
        DenyResetButton.addTarget(self, action:#selector(deny), for: .touchUpInside)
        
        //Restart Message
        ResetMessage.numberOfLines = 4
        ResetMessage.text = "Are you sure you want to reset? \n(Creates new maze)"
        ResetMessage.frame = CGRect(origin: CGPoint(x: sW*(0.5)-50,y :sH*(1/8)), size: CGSize(width: 145, height: 100))
        ResetMessage.transform = CGAffineTransform(scaleX: 2,y: 2);
        
        //Game title
        Title.numberOfLines = 3
        Title.text = "Can you escape the maze?"
        Title.frame = CGRect(origin: CGPoint(x: sW*(0.5)-(145/2),y :sH*(1/8)), size: CGSize(width: 145, height: 100))
        Title.textAlignment = .center
        Title.transform = CGAffineTransform(scaleX: 3,y: 3);
        
        //Start Button
        Start.setTitle("Start", for: .normal)
        Start.setTitleColor(UIColor.black, for: .normal)
        Start.frame = CGRect(origin: CGPoint(x: sW*(0.5)-25,y :sH*(3/8)), size: CGSize(width: 50, height: 50))
        Start.transform = CGAffineTransform(scaleX: 4,y: 4);
        Start.addTarget(self, action:#selector(start), for: .touchUpInside)
        
        //About button
        About.setTitle("About", for: .normal)
        About.setTitleColor(UIColor.black, for: .normal)
        About.frame = CGRect(origin: CGPoint(x: sW*(0.5)-25,y :sH*(5/8)), size: CGSize(width: 50, height: 50))
        About.transform = CGAffineTransform(scaleX: 4,y: 4);
        About.addTarget(self, action:#selector(about), for: .touchUpInside)
        
        //About Message
        AboutMessage.numberOfLines = 20
        AboutMessage.text = "About message goes here"
        AboutMessage.frame = CGRect(origin: CGPoint(x: sW*(0.5)-(145/2),y :sH*(1/8)), size: CGSize(width: 145, height: 100))
        AboutMessage.textAlignment = .center
        
        //Back Button from about message
        AboutBack.setTitle("Back", for: .normal)
        AboutBack.setTitleColor(UIColor.black, for: .normal)
        AboutBack.frame = CGRect(origin: CGPoint(x: 0,y :15), size: CGSize(width: 100, height: 30))
        AboutBack.addTarget(self, action:#selector(backToStart), for: .touchUpInside)
        
        self.view.addSubview(Start)
        self.view.addSubview(Title)
        self.view.addSubview(About)
        
    }
    let LeftButton = UIButton()
    let RightButton = UIButton()
    let ForwardButton = UIButton()
    
    let PauseMenu = UIButton()
    let PauseReset = UIButton()
    let PauseRestart = UIButton()
    let PauseMainMenu = UIButton()
    let BackToMaze = UIButton()
    
    //Resets Maze and back at start
    let ConfirmResetButton = UIButton()
    let DenyResetButton = UIButton()
    let ResetMessage = UILabel()
    
    //Moves back to start
    let ConfirmRestartButton = UIButton()
    let DenyRestartButton = UIButton()
    let RestartMessage = UILabel()
    
    let Title = UILabel()
    let Start = UIButton()
    let About = UIButton()
    let AboutMessage = UILabel()
    
    let AboutBack = UIButton()
    
    
    var xpos:Float = 0.0
    var zpos:Float = 0.0
    
    @objc func pauseMenu(){
        xpos = camera.position.x
        zpos = camera.position.z
        self.camera.position = SCNVector3(x: -300, y: 150, z: -300)
        LeftButton.removeFromSuperview()
        RightButton.removeFromSuperview()
        ForwardButton.removeFromSuperview()
        PauseMenu.removeFromSuperview()
        self.view.addSubview(PauseReset)
        self.view.addSubview(PauseRestart)
        self.view.addSubview(PauseMainMenu)
        self.view.addSubview(BackToMaze)
    }
    
    @objc func pauseResetMenu(){
        PauseReset.removeFromSuperview()
        PauseRestart.removeFromSuperview()
        PauseMainMenu.removeFromSuperview()
        BackToMaze.removeFromSuperview()
        self.view.addSubview(ConfirmResetButton)
        self.view.addSubview(DenyResetButton)
        self.view.addSubview(ResetMessage)
        
    }
    @objc func pauseRestartMenu(){
        PauseReset.removeFromSuperview()
        PauseRestart.removeFromSuperview()
        PauseMainMenu.removeFromSuperview()
        BackToMaze.removeFromSuperview()
        self.view.addSubview(ConfirmRestartButton)
        self.view.addSubview(DenyRestartButton)
        self.view.addSubview(RestartMessage)
        
    }
    @objc func backToMaze(){
        lookAtNode.position = SCNVector3(x: 5, y: 0, z: 5)
        self.camera.position = SCNVector3(x: 5, y: 30, z: -20)
        PauseReset.removeFromSuperview()
        PauseRestart.removeFromSuperview()
        PauseMainMenu.removeFromSuperview()
        BackToMaze.removeFromSuperview()
        self.view.addSubview(LeftButton)
        self.view.addSubview(RightButton)
        self.view.addSubview(ForwardButton)
        self.view.addSubview(PauseMenu)

    }
    
    @objc func pauseMainMenu(){
        PauseReset.removeFromSuperview()
        PauseRestart.removeFromSuperview()
        PauseMainMenu.removeFromSuperview()
        BackToMaze.removeFromSuperview()
        self.view.addSubview(Start)
        self.view.addSubview(Title)
        self.view.addSubview(About)
    }
    
    
    @objc func reset(){
        lookAtNode.position = SCNVector3(x: 5, y: 0, z: 5)
        self.camera.position = SCNVector3(x: 5, y: 30, z: -20)
        unloadMaze()
        generateMaze()
        loadMaze()
        self.view.addSubview(LeftButton)
        self.view.addSubview(RightButton)
        self.view.addSubview(ForwardButton)
        self.view.addSubview(PauseMenu)
        ConfirmResetButton.removeFromSuperview()
        DenyResetButton.removeFromSuperview()
        ResetMessage.removeFromSuperview()
    }
    
    @objc func restart(){
        lookAtNode.position = SCNVector3(x: 5, y: 0, z: 5)
        self.camera.position = SCNVector3(x: 5, y: 30, z: -20)
        self.view.addSubview(LeftButton)
        self.view.addSubview(RightButton)
        self.view.addSubview(ForwardButton)
        self.view.addSubview(PauseMenu)
        ConfirmRestartButton.removeFromSuperview()
        DenyRestartButton.removeFromSuperview()
        RestartMessage.removeFromSuperview()
    }
    
    @objc func deny(){
        self.view.addSubview(PauseReset)
        self.view.addSubview(PauseRestart)
        self.view.addSubview(PauseMainMenu)
        self.view.addSubview(BackToMaze)
        ConfirmResetButton.removeFromSuperview()
        DenyResetButton.removeFromSuperview()
        ResetMessage.removeFromSuperview()
        ConfirmRestartButton.removeFromSuperview()
        DenyRestartButton.removeFromSuperview()
        RestartMessage.removeFromSuperview()
    }

    @objc func start(){
        lookAtNode.position = SCNVector3(x: 5, y: 0, z: 5)
        self.camera.position = SCNVector3(x: 5, y: 30, z: -20)
        unloadMaze()
        generateMaze()
        loadMaze()
        Start.removeFromSuperview()
        About.removeFromSuperview()
        Title.removeFromSuperview()
        self.view.addSubview(LeftButton)
        self.view.addSubview(RightButton)
        self.view.addSubview(ForwardButton)
        self.view.addSubview(PauseMenu)
    }
    @objc func about(){
        Start.removeFromSuperview()
        Title.removeFromSuperview()
        About.removeFromSuperview()
        self.view.addSubview(AboutBack)
        self.view.addSubview(AboutMessage)
    }
    @objc func backToStart(){
        AboutBack.removeFromSuperview()
        AboutMessage.removeFromSuperview()
        self.view.addSubview(Start)
        self.view.addSubview(Title)
        self.view.addSubview(About)
    }
    
    @objc func leftButton(){
        if(lookAtNode.position.z > camera.position.z) {
            self.camera.position = SCNVector3(x: camera.position.x - 15, y: 30, z: camera.position.z + 25)
            Xplus()
        } else if(lookAtNode.position.x > camera.position.x) {
            self.camera.position = SCNVector3(x: camera.position.x + 20, y: 30, z: camera.position.z + 15)
            Zminus()
        } else if(lookAtNode.position.z < camera.position.z) {
            self.camera.position = SCNVector3(x: camera.position.x + 15, y: 30, z: camera.position.z - 20)
            Xminus()
        } else if(lookAtNode.position.x < camera.position.x) {
            self.camera.position = SCNVector3(x: camera.position.x - 20, y: 30, z: camera.position.z - 20)
            Zplus()
        }
    }
    
    @objc func rightButton(){
        if(lookAtNode.position.z > camera.position.z) {
            self.camera.position = SCNVector3(x: camera.position.x + 15, y: 30, z: camera.position.z + 25)
            Xminus()
        } else if(lookAtNode.position.x > camera.position.x) {
            self.camera.position = SCNVector3(x: camera.position.x + 20, y: 30, z: camera.position.z - 20)
            Zplus()
        } else if(lookAtNode.position.z < camera.position.z) {
            self.camera.position = SCNVector3(x: camera.position.x - 15, y: 30, z: camera.position.z - 20)
            Xplus()
        } else if(lookAtNode.position.x < camera.position.x) {
            self.camera.position = SCNVector3(x: camera.position.x - 20, y: 30, z: camera.position.z + 15)
            Zminus()
        }
    }
    
    @objc func forwardButton(){
        if(lookAtNode.position.z > camera.position.z) {
            self.camera.position = SCNVector3(x: camera.position.x, y: 30, z: camera.position.z + 5)
            Zplus()
        } else if(lookAtNode.position.x > camera.position.x) {
            self.camera.position = SCNVector3(x: camera.position.x + 5, y: 30, z: camera.position.z)
            Xplus()
        } else if(lookAtNode.position.z < camera.position.z) {
            self.camera.position = SCNVector3(x: camera.position.x, y: 30, z: camera.position.z - 5)
            Zminus()
        } else if(lookAtNode.position.x < camera.position.x) {
            self.camera.position = SCNVector3(x: camera.position.x - 5, y: 30, z: camera.position.z)
            Xminus()
        }
    }
    
    func Xplus() {
        //self.camera.position = SCNVector3(x: camera.position.x + 5, y: 30, z: camera.position.z)
        lookAtNode.position = SCNVector3(x: lookAtNode.position.x + 5, y: 0, z: lookAtNode.position.z)
    }
    func Zplus() {
        //self.camera.position = SCNVector3(x: camera.position.x, y: 30, z: camera.position.z + 5)
        lookAtNode.position = SCNVector3(x: lookAtNode.position.x, y: 0, z: lookAtNode.position.z + 5)
    }
    func Xminus() {
        //self.camera.position = SCNVector3(x: camera.position.x - 5, y: 30, z: camera.position.z)
        lookAtNode.position = SCNVector3(x: lookAtNode.position.x - 5, y: 0, z: lookAtNode.position.z)
    }
    func Zminus() {
        //self.camera.position = SCNVector3(x: camera.position.x, y: 30, z: camera.position.z - 5)
        lookAtNode.position = SCNVector3(x: lookAtNode.position.x, y: 0, z: lookAtNode.position.z - 5)
    }
    
    func initView() {
        sceneView = SCNView(frame: self.view.frame)
        sceneView.antialiasingMode = .multisampling2X
        sceneView.scene = SCNScene()
        self.view.addSubview(sceneView)
        
        let groundGeometry = SCNFloor()
        groundGeometry.reflectivity = 0
        let groundMaterial = SCNMaterial()
        groundMaterial.diffuse.contents = UIColor.white
        groundGeometry.materials = [groundMaterial]
        ground = SCNNode(geometry: groundGeometry)
        
        //finding center of maze
        let lookAtX = (Float(testMaze[0].count / 2)) * 5
        let lookAtZ = (Float(testMaze.count / 2)) * 5
        
        lookAtNode.position = SCNVector3(x: 5, y: 0, z: 5)
        
        let camera = SCNCamera()

        camera.zFar = 1000
        self.camera = SCNNode()
        self.camera.camera = camera
        constraint = SCNLookAtConstraint(target: lookAtNode)
        constraint.isGimbalLockEnabled = true
       
        self.camera.constraints = [constraint]
        self.camera.position = SCNVector3(x: 5, y: 30, z: -20)
        cameraOrbit.addChildNode(self.camera)
        
        let ambientLight = SCNLight()
        ambientLight.color = UIColor.darkGray
        ambientLight.type = SCNLight.LightType.ambient
        self.camera.light = ambientLight/**/
        
        
        let spotLight = SCNLight()
        spotLight.type = SCNLight.LightType.spot
        spotLight.castsShadow = true
        spotLight.spotInnerAngle = 80.0
        spotLight.spotOuterAngle = 90.0
        spotLight.zFar = 500
        light = SCNNode()
        light.light = spotLight
        light.position = SCNVector3(x: -25, y: 15, z: -25)
        //light.position = SCNVector3(x: lookAtX, y: 100, z: lookAtZ)
        light.constraints = [constraint]
    }
    
    func initMaterial() {
        //loading materials with correct color
        materialRed.diffuse.contents = UIColor.red
        materialCyan.diffuse.contents = UIColor.cyan
    }
    
    func initElements() {
        sceneView.allowsCameraControl = true
        sceneView.scene?.rootNode.addChildNode(cameraOrbit)
        
//        sceneView.scene?.lookAtNode.addChildNode(cameraOrbit)
        sceneView.scene?.rootNode.addChildNode(ground)
        sceneView.scene?.rootNode.addChildNode(light)
    }
    
    func generateMaze() {
        print("Generating Maze")
//        https://en.wikipedia.org/wiki/Maze_generation_algorithm
        
        ////         8x8 array with walls
        //        var testArray = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]
        
        
        //        8x8 array
        var Array1 = gridTemplate
        
        let mazeSize = Array1.count - 1
        
        var currentPos = 0
        var newPos = 0
        
        //        random starting position, change int to UInt32 for compatibility
        let startingPos = Int(arc4random_uniform(UInt32(mazeSize)))
        //print(startingPos)
        
        currentPos = startingPos
        
        Array1[startingPos] = 1
        
        //print(Array1)
        while Array1.contains(0) {
            var neighbors = [Int]()
            var neighborPos = 0
            
            //            Test for neighbors
            
            //            Left neighbor
            neighborPos = currentPos % 8
            if (neighborPos - 1) >= 0{
                neighborPos = currentPos-1
                if Array1[neighborPos] == 0 {
                    neighbors.append(neighborPos)
                }
                else {
                    let visitChance = Int(arc4random_uniform(UInt32(100)))
                    if visitChance < 50 {
                        neighbors.append(neighborPos)
                    }
                }
                
            }
            
            //            Right neighbor
            neighborPos = currentPos % 8
            if (neighborPos + 1) != 8{
                neighborPos = currentPos+1
                if Array1[neighborPos] == 0 {
                    neighbors.append(neighborPos)
                }
                else {
                    let visitChance = Int(arc4random_uniform(UInt32(100)))
                    if visitChance < 50 {
                        neighbors.append(neighborPos)
                    }
                }
            }
            
            //            Top neighbor
            neighborPos = currentPos-8
            if neighborPos >= 0{
                if Array1[neighborPos] == 0 {
                    neighbors.append(neighborPos)
                }
                else {
                    let visitChance = Int(arc4random_uniform(UInt32(100)))
                    if visitChance < 50 {
                        neighbors.append(neighborPos)
                    }
                }
            }
            
            //            Bottom neighbor
            neighborPos = currentPos+8
            if neighborPos <= 63{
                if Array1[neighborPos] == 0 {
                    neighbors.append(neighborPos)
                }
                else {
                    let visitChance = Int(arc4random_uniform(UInt32(100)))
                    if visitChance < 50 {
                        neighbors.append(neighborPos)
                    }
                }
            }
            
            if neighbors.count > 0 {
                let randNeighbor = Int(arc4random_uniform(UInt32(neighbors.count-1)))
                
                Array1[neighbors[randNeighbor]] = 1
                newPos = neighbors[randNeighbor]
                
            }
            else {
                
                newPos = 0
                
                while newPos == 0 {
                    let tempPos = Int(arc4random_uniform(UInt32(mazeSize)))
                    if Array1[tempPos] == 0 {
                        newPos = tempPos
                        Array1[newPos] = 1
                        currentPos = newPos
                    }
                }
            }
            
            if abs(currentPos-newPos) == 1 {
                var col = currentPos % 8
                var row = ((currentPos-col) / 8) + 1
                
                col = (((col+1)*2) - 1) + (newPos-currentPos)
                row = (row*2) - 1
                
                //print("Right/Left")
                
                //print(testMaze)
                //print(row, col)
                
                testMaze[row][col] = 0
                //print(testMaze)
            }
            else if abs(currentPos-newPos) == 8{
                var col = currentPos % 8
                var row = ((currentPos-col) / 8) + 1
                
                let newCol = newPos % 8
                let newRow = ((newPos-newCol)/8) + 1
                
                col = ((col+1)*2) - 1
                row = ((row*2) - 1) + (newRow - row)
                
                testMaze[row][col] = 0
            }
            currentPos = newPos
        }
        print("Generated Maze")
    }
    
    func unloadMaze(){
        print(wall.count)
        let cont = wall.count
        var i = 0
        while(i<cont){
            wall[i].removeFromParentNode()
            i=i+1;
        }
        wall.removeAll()
        print(wall.count)
    }
    
    func loadMaze() {
        print("loading Maze")
        let wallGeometry = SCNBox(width: 5, height: 8, length: 5, chamferRadius: 0)
        wallGeometry.materials = [materialRed]
        
        var xpos = 0.0
        var zpos = 0.0
        let ypos = 4
        var i = 0
        var xcont = 0
        
        while(i < testMaze.count){
            for item in testMaze[i]{
                switch (item){
                case 0:
                    xpos=xpos+5
                case 1:
                    wall.append(SCNNode(geometry: wallGeometry))
                    wall[xcont].position = SCNVector3(x: Float(xpos), y: Float(ypos), z: Float(zpos))
                    xcont = xcont + 1;
                    xpos = xpos + 5;
                default:
                    print("this shouldn't happen")
                }
            }
            //print("Array",i)
            xpos = 0
            zpos = zpos+5
            i = i+1;
        }
        print("finished maze")
        
        for child in wall {
            //print(child.position)
            sceneView.scene?.rootNode.addChildNode(child)
        }
        
        let lookAtGeometry = SCNCylinder(radius: 1.0, height: 15.0)
        lookAtGeometry.materials = [materialCyan]
        
        lookAtNode.geometry = lookAtGeometry
        sceneView.scene?.rootNode.addChildNode(lookAtNode)
        
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}

