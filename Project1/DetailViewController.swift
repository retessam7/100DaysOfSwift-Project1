//
//  DetailViewController.swift
//  Project1
//
//  Created by VII on 19.10.2024.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    // this is connected to something in Interface Builder
    
    var viewCont = ViewController()
    
    var selectedImage: String?
    var selectedPictureNumber = 0
    var totalPictures = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        
        title = "Picture \(selectedPictureNumber) of \(totalPictures)"
        
        navigationItem.largeTitleDisplayMode = .never
        // we want “Storm Viewer” to appear big, but the detail screen to look normal
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        // the .action system item displays an arrow coming out of a box
        // the action parameter is saying "when you're tapped, call the shareTapped() method," and the target parameter tells the button that the method belongs to the current view controller – self.
        // #selector tell the Swift compiler that a method called "shareTapped" will exist, and should be triggered when the button is tapped

        // checks and unwraps the optional in selectedImage:
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
            // UIImage is the data type you'll use to load image data, such as PNG or JPEGs
            
            if let currentCount = ImageCounter.shared.fileNameCounter["\(imageToLoad)"] {
                ImageCounter.shared.fileNameCounter["\(imageToLoad)"] = currentCount + 1
                save()
            } else {
                ImageCounter.shared.fileNameCounter["\(imageToLoad)"] = 1
                save()
            }
            print(ImageCounter.shared.fileNameCounter)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // the super prefix means "tell my parent data type that these methods were called."
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // In this instance, it means that it passes the method on to UIViewController, which may do its own processing.
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        // can send photos via AirDrop, post to Twitter, and much more
        // using #selector you’ll always need to use @objc too
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, "\(selectedImage!)"], applicationActivities: [])
        // is the iOS method of sharing content with other apps and services.
        // passing an empty array into the second parameter, because our app doesn't have any services to offer
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        // tell iOS where the activity view controller should be anchored – where it should appear from.
        present(vc, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(ImageCounter.shared.fileNameCounter) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "ImageCounter.shared.fileNameCounter")
        } else {
            print("Failed to save count.")
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "ImageCounter.shared.fileNameCounter") as? Data {
            let jsonDecoder = JSONDecoder()
            
            if let decodedData = try? jsonDecoder.decode([String: Int].self, from: savedData) {
                ImageCounter.shared.fileNameCounter = decodedData
            }
        }
    }
}
