//
//  RecastController.swift
//  d07
//
//  Created by Suliac LE-GUILLOU on 4/4/18.
//  Copyright © 2018 Suliac LE-GUILLOU. All rights reserved.
//

import UIKit
import RecastAI
import ForecastIO

class RecastController: UIViewController {
    
    var bot: RecastAIClient?
    let client: DarkSkyClient = DarkSkyClient(apiKey: "3f881794619217a89bdc84cfcc5dc338")
    
    var sendButton: UIButton = {
        let b = UIButton()
        b.setTitle("Send", for: .normal)
        b.backgroundColor = UIColor(displayP3Red: 10/255, green: 146/255, blue: 242/255, alpha: 1)
        
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(makeRequest), for: .touchUpInside)
        return b
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        
        tf.backgroundColor = UIColor(white: CGFloat(0.95), alpha: CGFloat(1.0))
        tf.placeholder = "Your question ?"
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let anserLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        
        return l
    }()
    
    func setConstraint() {
        sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        sendButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        
        anserLabel.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        anserLabel.bottomAnchor.constraint(equalTo: sendButton.topAnchor).isActive = true
        anserLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func getWeather(_ response: Response) {
        let location = response.get(entity: "location")
        var lat: Double?
        var long: Double?
        
        if location != nil {
            let location = location!
            for s in location {
                print(s.key, s.value)
                if s.key == "lat" {
                    lat = Double(s.value as! NSNumber)
                } else if s.key == "lng" {
                    long = Double(s.value as! NSNumber)
                }
            }
            if lat != nil && long != nil {
                client.getForecast(latitude: lat!, longitude: long!) { result in
                    switch result {
                    case .success(let currentForecast, let requestMetadata):
                        self.anserLabel.text = currentForecast.currently?.summary
                        break
                    case .failure(let error):
                        self.anserLabel.text = "Error."
                    }
                    
                }
            }
        }
    }
    
    func recastRequestDone(_ response : Response)
    {
        let intent = response.intent()
        
        if intent != nil && intent?.slug == "weather" {
            getWeather(response)
        } else {
            anserLabel.text = "Error."
        }
    }
    
    func recastRequestError(_ error : Error)
    {
        print("Error : \(error)")
    }
    
    @objc func makeRequest() {
        if (!(self.textField.text?.isEmpty)!)
        {
            self.bot?.textRequest(self.textField.text!, successHandler: recastRequestDone, failureHandle: recastRequestError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .clear
        
        self.title = "RecastRequest"
        
        view.addSubview(sendButton)
        view.addSubview(textField)
        view.addSubview(anserLabel)
        
        setConstraint()
        
        self.bot = RecastAIClient(token : "14c74ea87bacbfca95903db49809f58d")
        
        client.units = .si
    }
}
