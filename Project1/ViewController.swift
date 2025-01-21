//
//  ViewController.swift
//  Project1
//
//  Created by VII on 15.10.2024.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Storm Viewer"
        
        // each new view controller that pushed onto the navigation controller stack inherits the style of its predecessor
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
        
        performSelector(inBackground: #selector(loadPictures), with: nil)
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // the method that sets how many rows should appear in the table
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // to specify what each row should look like
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        // creates a new constant called cell by dequeuing a recycled cell from the table
        cell.textLabel?.text = pictures[indexPath.row]
        // it gives the text label of the cell the same text as a picture in our array
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // the if let and as? typecast comes in: it means “I want to treat this is a DetailViewController so please try and convert it to one.”
            // 2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            vc.totalPictures = pictures.count
            vc.selectedPictureNumber = indexPath.row + 1
            
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func shareApp() {
        let shareApp = "I recommend you StormViewer"
        let avc = UIActivityViewController(activityItems: [shareApp], applicationActivities: [])
        
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(avc, animated: true)
    }
    
    @objc func loadPictures() {
        let fm = FileManager.default // This is a data type that lets us work with the filesystem
        let path = Bundle.main.resourcePath! // Declares a constant called path that is set to the resource path of our app's bundle
        let items = try! fm.contentsOfDirectory(atPath: path) // The items constant will be an array of strings containing filenames
        // try! keyword, which means “don’t make me catch errors, because they won’t happen.”
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item) // this is a picture to load!
            }
        }
        pictures.sort()
    }
}



// To give you an idea of how far you've come, here are just some of the things we've covered: table views and image views, app bundles, FileManager, typecasting, view controllers, storyboards, outlets, Auto Layout, UIImage, and more.
