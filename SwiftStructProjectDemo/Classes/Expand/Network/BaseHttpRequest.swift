//
//  BaseHttpRequest.swift
//  SwiftStructProject
//
//  Created by WeiHu on 2016/10/17.
//  Copyright © 2016年 WeiHu. All rights reserved.
//

import Foundation
import Alamofire

enum RequestMethod : Int {
    case Get    // Get
    case POST   // POST
}
enum RequestSerializerType : Int {
    case HTTP       // HTTP
    case JSON       // JSON
}
enum ResponseSerializerType : Int {
    case HTTP       // HTTP
    case JSON       // JSON
}
enum RequestPriority : Int {
    case Low       // Low
    case Default   // Default
    case High      //High
}

typealias AFConstructingBlock = (AFMultipartFormData) -> Void
typealias AFURLSessionTaskProgressBlock = (Progress) -> Void

typealias RequestCompletionBlock = (BaseHttpRequest) -> Void

protocol RequestDelegate {
//    optional
}
class BaseHttpRequest: DataRequest {
    // MARK -  Request and Response Information
    
    var responseData: NSData?
    var responseString: NSString?
    var responseObject: Any?
    var error: NSError?
    var cancelled: Bool?
    var executing: Bool?
    
    // MARK -  Request Configuration
    var tag: NSInteger?
    var userInfo: NSDictionary?
    
    var successCompletionBlock: RequestCompletionBlock?
    var failureCompletionBlock: RequestCompletionBlock?
    var constructingBodyBlock: AFConstructingBlock?
    var resumableDownloadPath: NSString?
    var resumableDownloadProgressBlock: AFURLSessionTaskProgressBlock?
    var requestPriority: RequestPriority = .Default
   
    
}
private extension BaseHttpRequest{
  
}

// MARK -  Request Configuration
private extension BaseHttpRequest{
    func setCompletionBlockWithSuccess(success: @escaping RequestCompletionBlock, failure: @escaping RequestCompletionBlock) {
        self.successCompletionBlock = success
        self.failureCompletionBlock = failure
    }
    func clearCompletionBlock() {
        self.successCompletionBlock = nil;
        self.failureCompletionBlock = nil;
    }

}
// MARK -  Request Action
private extension BaseHttpRequest{
    func start() {
        BaseNetworkAgent.sharedAgent.addRequest(request: self)
    }
    func stop() {
        BaseNetworkAgent.sharedAgent.cancelRequest(request: self)
    }
    func startWithCompletionBlockWithSuccess(success: @escaping RequestCompletionBlock, failure: @escaping RequestCompletionBlock) {
        self.setCompletionBlockWithSuccess(success: success, failure: failure)
        self.start()
    }
}
// MARK -  Subclass Override
extension BaseHttpRequest{
    func requestCompletePreprocessor() {
        
    }
    func requestCompleteFilter() {
        
    }
    func requestFailedPreprocessor() {
        
    }
    func requestFailedFilter() {
        
    }
    func baseUrl() -> String{
       return ""
    }
    func requestUrl() -> String{
        return ""
    }
    func requestTimeoutInterval() -> TimeInterval {
        
       return 60
    }
    func requestArgument() -> [String: Any]?{
        return ["": ""]
    }
    func cacheFileNameFilterForRequestArgument(argument: Any) -> Any{
        return 0
    }
    func requestMethod() -> RequestMethod{
        return .POST
    }
    func requestSerializerType() -> RequestSerializerType{
        return .HTTP
    }
    func responseSerializerType() -> ResponseSerializerType {
         return .JSON
    }
    func requestAuthorizationHeaderFieldArray() -> [String]? {
        return nil
    }
    func requestHeaderFieldValueDictionary() -> [String:String]? {
        return nil
    }
    func buildCustomUrl() -> String? {
        return nil
    }
    func allowsCellularAccess() -> Bool {
        return false
    }
    func jsonValidator() -> Any {
        return 0
    }
    func statusCodeValidator() -> Bool{
        return false
    }
    
}
