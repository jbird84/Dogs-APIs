//
//  ViewController.swift
//  Dogs&APIs
//
//  Created by Kinney Kare on 9/8/21.
//

import UIKit

// (1) Create response struct
struct APIResponse:Codable {
    let message: URL
}

class ViewController: UIViewController {
    
    @IBOutlet weak var dogImage: UIImageView!
    
    // (2) Create URL String
    let urlString = "https://dog.ceo/api/breeds/image/random"
    
    @IBAction func showRandomDogPressed(_ sender: Any) {
        fetchPhotos()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // (3) Function to go out and grab photos
    func fetchPhotos() {
        
        //add a guard let statement to convert the URL String to a URL Object
        guard let url = URL(string: urlString) else {
            //if there is an error/issue converting handle it here
            print("Issue converting URL String to a URL Object.")
            return
        }
        
        //NOTE: we add the [weak self] to prevent a memory leak
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                //handle issues/errors here
                print(error?.localizedDescription ?? "No localized description available. Failed to get data.")
                return
            }
            //Successfully! here we will add a print statement to show success.
            print("Successfully received data")
            
            //NOTE: if successful this data now needs to be converted from the bytes that it comes back as into JSON. We can acheive this by using codable.
            
            //Use this do catch to try JSONDecoder to take the APIResponse and turn it into JSON.
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.global().async {
                    if let imagedata = try? Data(contentsOf: jsonResult.message) {
                        DispatchQueue.main.async {
                            //convert imagedata from JSON to UIImage and set it to our dogImage (imageView).
                            self?.dogImage.image = UIImage(data: imagedata)
                        }
                    }
                }
            } catch {
                //if there is an issue handle it here
                print(error)
            }
        }
        task.resume()
    }
}


