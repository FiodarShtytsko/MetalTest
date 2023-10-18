//
//  ViewController.swift
//  MetalTest
//
//  Created by Fiodar Shtytsko on 17/10/2023.
//

import UIKit
import AVFoundation
import MetalKit

class CaptureViewController: UIViewController {

    @IBOutlet private weak var metalView: UIView!
    @IBOutlet private weak var recordButton: UIButton!
    @IBOutlet private weak var vhsButton: UIButton!

    private var videoCaptureSession: AVCaptureSession?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var vhsShaderEnabled = false
    private var isRecording = false

//    private var metalRenderer: MetalR?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMetalView()
        setupCamera()
    }

    private func setupMetalView() {
//        metalRenderer = MetalRenderer(metalView: metalView)
//        metalRenderer?.setup()
    }

    private func setupCamera() {
        videoCaptureSession = AVCaptureSession()
        videoCaptureSession?.sessionPreset = .high

        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if videoCaptureSession?.canAddInput(input) ?? false {
                videoCaptureSession?.addInput(input)
            }

            let previewLayer = AVCaptureVideoPreviewLayer(session: videoCaptureSession!)
            previewLayer.frame = metalView.bounds
            metalView.layer.addSublayer(previewLayer)
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.videoCaptureSession?.startRunning()
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    @IBAction func toggleRecording(_ sender: UIButton) {
        if isRecording {
            videoCaptureSession?.stopRunning()

            // Завершить запись и выполнить необходимые операции
            // Автоматический переход на второй экран
        } else {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.videoCaptureSession?.startRunning()
            }
            // Начать запись
        }
        isRecording.toggle()
    }

    @IBAction func toggleVHSShader(_ sender: UIButton) {
        vhsShaderEnabled.toggle()
//        metalRenderer?.enableVHSShader(vhsShaderEnabled)
    }
}

extension CaptureViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                    let ciImage = CIImage(cvImageBuffer: imageBuffer)
                    // Здесь вы можете использовать ciImage для дополнительной обработки
                }
        // Обработка видеофреймов и передача их для рендеринга
//        metalRenderer?.renderFrame(sampleBuffer: sampleBuffer)
    }
}


