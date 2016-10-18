//
//  BaseNetworkAgent.swift
//  SwiftStructProject
//
//  Created by WeiHu on 2016/10/17.
//  Copyright © 2016年 WeiHu. All rights reserved.
//

import UIKit
import Alamofire

let networkAgent = BaseNetworkAgent()

class BaseNetworkAgent: NSObject {
    private var _manager: AFHTTPSessionManager = AFHTTPSessionManager()
    private var _config: BaseNetworkConfig = BaseNetworkConfig.sharedNetworkConfig
    private var _jsonResponseSerializer: AFJSONResponseSerializer = AFJSONResponseSerializer()
    private var _requestsRecord: [NSInteger: DataRequest] = [NSInteger: DataRequest]()
    private var _processingQueue: DispatchQueue = DispatchQueue(label: "com.networkagent.processing")
    private var _lock: pthread_mutex_t?
    private var _allStatusCodes: NSIndexSet =  NSIndexSet()
//    private var _requestsRecord: Dictionary = [NSNumber: BaseHttpRequest]
    
    override init() {
        super.init()
        pthread_mutex_init(&_lock!, nil)
//        _manager?.securityPolicy = _config.securityPolicy
        _manager.responseSerializer = AFHTTPResponseSerializer()
        _manager.completionQueue = _processingQueue
        
    }
    class var sharedAgent: BaseNetworkAgent {
        return networkAgent
    }
    func buildRequestUrl(request: BaseHttpRequest) -> String {
        let detailUrl = request.requestUrl()
        if let temp: URL = URL(string: detailUrl),let _ = temp.host, let _ = temp.scheme {
            return detailUrl
        }
        var baseUrl: String = ""
        if !request.baseUrl().isEmpty {
            baseUrl = request.baseUrl()
        }
        var url = URL(string: baseUrl)
        if !baseUrl.isEmpty && !baseUrl.hasSuffix("/"){
            url = url?.appendingPathComponent("")
        }
        
        return URL(string: detailUrl, relativeTo: url)!.absoluteString
    }
    private func requestSerializerForRequest(request: BaseHttpRequest) -> AFHTTPRequestSerializer?{
       return nil
    }
    private func sessionTaskForRequest(request: BaseHttpRequest, error: ErrorPointer) -> URLSessionTask?{
        return nil
    }
    
    func addRequest(request: BaseHttpRequest) {
        var url: String = ""
        if let customUrlRequestUrlString = request.buildCustomUrl(){
            if !customUrlRequestUrlString.isEmpty {
                url = customUrlRequestUrlString
            }
        }
        //Method
        let method = request.requestMethod() == .Get ? HTTPMethod.get : HTTPMethod.post
        //encoding
        let encoding = request.requestSerializerType() == .HTTP ? URLEncoding.httpBody : URLEncoding.default
        // parameters
        let parameters = request.requestArgument()
        
        let dataRequest = self.request(url: url, method: method, parameters:parameters, encoding: encoding, headers: nil)
        
        self.addRequestToRecord(request: request)
        dataRequest?.resume()
    
    }
    func cancelRequest(request: BaseHttpRequest) {
        if let tast = request.task{
            tast.cancel()
            self.removeRequestFromRecord(request: request)
        }
    }
    func addRequestToRecord(request: BaseHttpRequest) {
        
        pthread_mutex_lock(&_lock!)
        if let tast = request.task{
            _requestsRecord[tast.taskIdentifier] = request
        }
        pthread_mutex_unlock(&_lock!)
    }
    func removeRequestFromRecord(request: BaseHttpRequest) {
        pthread_mutex_lock(&_lock!)
        if let tast = request.task{
            _requestsRecord.removeValue(forKey: tast.taskIdentifier)
        }
        pthread_mutex_unlock(&_lock!)
    }
    func handleRequestResult(dataResponse: DefaultDataResponse) {
        
     
    }
    
    func request(url: String, method: HTTPMethod,parameters: [String: Any]?, encoding: ParameterEncoding,headers: HTTPHeaders?) -> DataRequest?{
//      return SessionManager.default.request(url, method: method, parameters:parameters, encoding: encoding,headers: headers).responseData(completionHandler: {[unowned self] (dataResponse) in
//        self.handleRequestResult(dataResponse: dataResponse)
//      })

        return SessionManager.default.request(url, method: method, parameters:parameters, encoding: encoding,headers: headers).response(completionHandler: {[unowned self] (dataResponse) in
            self.handleRequestResult(dataResponse: dataResponse)
            })
    }
    func dataTaskWithHTTPMethod(method: String, requestSerializer: AFHTTPRequestSerializer, URLString: String, parameters: [String: Any],constructingBodyWithBlock: AFConstructingBlock?, error: ErrorPointer){
        
    }

    func cancelAllRequests(){
        
    }
  
}
