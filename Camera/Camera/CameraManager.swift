//
//  CameraManager.swift
//  Camera
//
//  Created by Khayrul on 2/9/22.
//

import Foundation
import AVFoundation

class CameraManager: ObservableObject {
    
        
    let session = AVCaptureSession()
    
    private let sessionQueue = DispatchQueue(label: "com.mymedicalhub.sessionQ")
    
    private let videoOutput = AVCaptureVideoDataOutput()
    
    private var status = Status.unconfigured

    
    enum Status {
        case unconfigured
        case configured
        case unauthorized
        case failed
        
    }
    
    static let shared = CameraManager()
    
    private init() {
        configure()
    }
    
    private func configure() {
        
        checkPermissions()
        
        sessionQueue.async {
          self.configureCaptureSession()
          self.session.startRunning()
        }

    }
    
    //check for camera's permission
    private func checkPermissions(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                break
            
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        
                    }
                }
            
            case .denied: // The user has previously denied access.
                return

            case .restricted: // The user can't grant access due to restrictions.
                return
            default:
                return
        }
        
    }
    
    private func configureCaptureSession() {
        guard status == .unconfigured else {
            return
        }
        session.beginConfiguration()
        do {
            session.commitConfiguration()
        }
        
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        
        guard let camera = device else {
          status = .failed
          return
        }
        
        do {
          let cameraInput = try AVCaptureDeviceInput(device: camera)
          
          if session.canAddInput(cameraInput) {
            session.addInput(cameraInput)
          } else {
            status = .failed
            return
          }
        } catch {
          status = .failed
          return
        }
        
        if session.canAddOutput(videoOutput) {
            
          session.addOutput(videoOutput)
          videoOutput.videoSettings =
            [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
          let videoConnection = videoOutput.connection(with: .video)
          videoConnection?.videoOrientation = .portrait
            
        } else {
          status = .failed
          return
        }
        
        status = .configured
    }
    
    func set(
      _ delegate: AVCaptureVideoDataOutputSampleBufferDelegate,
      queue: DispatchQueue
    ) {
      sessionQueue.async {
        self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
      }
    }

}
