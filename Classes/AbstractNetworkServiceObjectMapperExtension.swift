//
//  AbstractServiceObjectMapperExtension.swift
//
//
//  Created by Daniele Salvioni on 12/12/2017.
//  Copyright © 2017 Daniele Salvioni. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import NetworkManager

extension AbstractNetworkService
{
    //--------------------------------------------------------------
    fileprivate func performRestOperationWithObjectMapper<ResponseClass: BaseMappable>(_ restOperationType: NetworkServiceRestOperationType,
                                                                                       pathUrl: URLConvertible,
                                                                                       parameters: Parameters,
                                                                                       encoding: ParameterEncoding,
                                                                                       savedAuthType: NetworkServiceAuthType,
                                                                                       additionalServiceHeaders: HTTPHeaders = [:],
                                                                                       activityIndicator: ActivityIndicatorProtocol? = nil,
                                                                                       activityIndicatorMessage: String? = nil,
                                                                                       successBlock:@escaping (_ responseObject: ResponseClass) -> Void,
                                                                                       errorBlock:@escaping (_ error: Error, _ validResponse: Bool) -> Void)
    {
        let restConfiguration = self.setupRestOperation(savedAuthType: savedAuthType,
                                                        pathUrl: pathUrl,
                                                        additionalServiceHeaders: additionalServiceHeaders,
                                                        activityIndicator: activityIndicator,
                                                        activityIndicatorMessage: activityIndicatorMessage)
        
        Alamofire.request(restConfiguration.url,
                          method: restOperationType.alamofireType(),
                          parameters:parameters,
                          encoding:encoding,
                          headers:restConfiguration.headers).validate(contentType:Constants.Network.DefaultValidContentTypeArray).responseObject(queue: self.dispatchQueue,
                                                                                                                                                 keyPath: nil,
                                                                                                                                                 mapToObject: nil,
                                                                                                                                                 context: nil,
                                                                                                                                                 completionHandler:
        { (responseObject: DataResponse<ResponseClass>) in
            self.completionRestOperation(responseObject: responseObject,
                                         activityIndicator: activityIndicator,
                                         successBlock: successBlock,
                                         errorBlock: errorBlock)
        })
    }
    
    //--------------------------------------------------------------
    public func performRestOperation<ResponseMappedClass :AnyObject>(_ restOperationType: NetworkServiceRestOperationType,
                                                                     pathUrl: URLConvertible,
                                                                     parameters: Parameters = [:],
                                                                     encoding: ParameterEncoding = URLEncoding.queryString,
                                                                     savedAuthType: NetworkServiceAuthType,
                                                                     additionalServiceHeaders: HTTPHeaders = [:],
                                                                     activityIndicator: ActivityIndicatorProtocol? = nil,
                                                                     activityIndicatorMessage: String? = nil,
                                                                     successBlock:@escaping (_ responseObject: ResponseMappedClass) -> Void,
                                                                     errorBlock:@escaping (_ error: Error, _ validResponse: Bool) -> Void) where ResponseMappedClass: BaseMappable
    {
        if self.canDoRestOperation(errorBlock: errorBlock) != true { return }
        
        self.performRestOperationWithObjectMapper(restOperationType,
                                                  pathUrl: pathUrl,
                                                  parameters: parameters,
                                                  encoding: encoding,
                                                  savedAuthType: savedAuthType,
                                                  activityIndicator: activityIndicator,
                                                  activityIndicatorMessage: activityIndicatorMessage,
                                                  successBlock: successBlock,
                                                  errorBlock: errorBlock)
    }
}
