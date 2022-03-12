//
//  ViewController.swift
//  ExampleApp
//
//  Created by Shu on 2022/03/06.
//

import UIKit
import Combine
import WebAuthnSwift
import Alamofire

class ViewController: UIViewController {

    private var cancellables = Set<AnyCancellable>()
    
    let sdk = WebAuthnSwift(apiKey: "7kx6vx9p9gZmqrtvHjRTOiSXMkAfZB3s5u3yjLehQHQCtjWrjAk9XlQHR2IOqpuR")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    
        sdk.setProfile()
        
        let task = { (credifyId: String) -> Future<Void, Error> in
            return Future() { promise in
                AF.request("https://dev-demo-api.credify.ninja/housecare/push-claims",
                           method: .post,
                           parameters: ["id": "1234", "credify_id": credifyId],
                           encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON { data in
                    switch data.result {
                    case .success:
                        promise(.success(()))
                    case .failure:
                        print("demo org issue")
                    }
                }
            }
        }
        sdk.setClaimTokenTask(pushClaimTokensTask: task)
        
        
//        WebAuthnSwift().startFlow()
        sdk.getOffers()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in }, receiveValue: { [sdk] res in
                print(res)
                
                sdk.showOffer(res.first!)
            }).store(in: &cancellables)
        
//        WebAuthnSwift().startAuthFlow()
    }


}

