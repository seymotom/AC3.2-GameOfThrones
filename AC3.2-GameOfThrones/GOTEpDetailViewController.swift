//
//  GOTEpDetailViewController.swift
//  AC3.2-GameOfThrones
//
//  Created by Tom Seymour on 10/13/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class GOTEpDetailViewController: UIViewController {
    
    var thisGOTEpisode: GOTEpisode!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seasonEpLabel: UILabel!
    @IBOutlet weak var airdateRuntimeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareScreen()
    }
    
    func prepareScreen() {
        navigationItem.title = thisGOTEpisode.name
        view.backgroundColor = UIColor.lightGray
        
//        imageView.image = getImage(urlString: thisGOTEpisode.imageOriginal)
        
        
        self.downloadImage(urlString: thisGOTEpisode.imageOriginal!) { (returnedData: Data) in
            
                self.imageView.image = UIImage(data: returnedData)
                DispatchQueue.main.async { self.view.reloadInputViews() }
            
        }
        titleLabel.text = thisGOTEpisode.name
        seasonEpLabel.text = "Season \(thisGOTEpisode.season), episode \(thisGOTEpisode.number)"
        airdateRuntimeLabel.text = "First aired: \(thisGOTEpisode.airdate),  running time: \(thisGOTEpisode.runtime) minutes."
        summaryLabel.text = "Summary:  " + thisGOTEpisode.summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func downloadImage(urlString: String, callback: @escaping (Data) -> () ) {
        guard let imageURL = URL(string: urlString) else { return }
        let session = URLSession.shared
        session.dataTask(with: imageURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered!: \(error!)")
            }
            guard let imageData = data else { return }
            callback(imageData)
            
        }.resume()
    }
    
    
    func getImage(urlString: String?) -> UIImage? {
        var theImageForThis: UIImage?
        var dataForImage: Data?
        if let unwrappedUrlString = urlString, let url = URL.init(string: unwrappedUrlString) {
            dataForImage = try? Data.init(contentsOf: url)
            if let unwrappedImageData = dataForImage {
                theImageForThis = UIImage.init(data: unwrappedImageData)
            }
        }
        return theImageForThis
    }
    
    func cropSummary(fromString: String) -> String {
        var temp = fromString.characters
        temp = temp.dropLast(4)
        temp = temp.dropFirst(3)
        return String(temp)
    }
    
    @IBAction func linkButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: thisGOTEpisode.url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }    
}
