//
//  NetworkApi.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 10/06/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//
import Foundation
import Alamofire
import RxSwift
class RestManager {
    
    private static let enableHTTPLogs: Bool = {
        let enableHTTPLogs: Bool
        #if ENABLE_HTTP_LOGS
        enableHTTPLogs = true
        #else
        enableHTTPLogs = false
        #endif
        
        return enableHTTPLogs
    }()
    
    private init () {
    }
    
    /**
     Wrapper around Alamofire.SessionManager. This field is initialized with default settings.
     */
    private static let manager :Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            RestEndpoints.ENDPOINT: .performDefaultEvaluation(validateHost: true)
        ]
        var configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest=45
        configuration.timeoutIntervalForResource=45
        return Alamofire.SessionManager(configuration: .default, serverTrustPolicyManager:ServerTrustPolicyManager(policies: serverTrustPolicies) )
    }()
    
    //MARK: Request methods
    /**
     Method for requesting data from the server
     - parameter url: URL to the server endpoint. Url should include both hostname, path and path queries.
     - parameter params : Request parameters as dictionary
     - parameter method: type of HttpMethod request.
     - parameter headers: specific request headers
     - parameter using completition :Closure that will be used for returning the data.
     - returns: Returns DataRequest object to enable cancelation of requests.
     */
    
    static func request<T: Codable> (url: String, method: HTTPMethod, params: Parameters?, headers: HTTPHeaders?,using completion: @escaping ((Result<T>) ->Void)) -> DataRequest? {
        return RestManager.manager.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseData { (response) in
                
                printResponse(response: response)
                
                switch (response.result){
                case .success (let value):
                    if let decodedObject: T = SerializationManager.parseData(jsonData: value) {
                        completion(.success(decodedObject))
                    }else {
                        completion(.failure(NetworkError.parseFailed))
                    }
                case .failure( let error):
                    completion(.failure(error))
                }
        }
    }
    
    /**
     Method that wraps AlamoFire network request to Observable. This method handles error propagation.
     - parameter url: URL to the server endpoint. Url should include both hostname, path and path queries.
     - parameter params : Request parameters as dictionary
     - parameter method: type of HttpMethod request.
     - parameter headers: specific request headers
     */
    static func requestObservable<T:Codable> (url: String, method: HTTPMethod, params: Parameters?, headers: HTTPHeaders?)->Observable<T>{
        return Observable<T>.create{ (emitter) -> Disposable in
            let request = RestManager.request(url: url,method: method, params: params, headers: headers, using: { (result:Result<T>) in
                do{
                    if(result.isSuccess){
                        if let value = result.value{
                            emitter.onNext(value)
                            emitter.onCompleted()
                        }else{
                            throw NetworkError.empty
                        }
                    }else{
                        throw result.error!
                    }
                }catch let error {
                    emitter.onError(error)
                }
            })
            return Disposables.create(with: {
                request?.cancel()
            })
        }
    }
    
    /**
     Method that prints server response with formatted value. Method will print response only if enableHTTP build flag is set to true.
     
     - parameter response: Response object.
     */
    private static func printResponse(response: DataResponse<Data>){
        if(self.enableHTTPLogs){
            if let data = response.data {
                
                do {
                    let url = response.request?.url?.absoluteString ?? String.empty
                    
                    //2. convert JSON data to JSON object
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    if jsonObject is NSArray || jsonObject is NSDictionary {
                        //3. convert back to JSON data by setting .PrettyPrinted option
                        let prettyJsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                        
                        //4. convert NSData back to NSString (use NSString init for convenience), later you can convert to String.
                        let prettyPrintedJson = String(data: prettyJsonData, encoding: String.Encoding.utf8) ?? .empty
                        
                        print("\n\n\nRestManager - URL: \(url) \n Response: \(prettyPrintedJson)")
                    }else{
                        print("\n\n\nRestManager - URL: \(url) \n Response: \(jsonObject)")
                    }
                    
                }catch let exception{
                    print(exception)
                }
            }
        }
    }
}
