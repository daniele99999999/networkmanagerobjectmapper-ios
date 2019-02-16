//
//  AbstractMockNetworkServiceObjectMapper.swift
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
import Utils

extension AbstractMockNetworkService
{
    //--------------------------------------------------------------
    public func performMockRestOperation<ResponseClass: AnyObject>(activityIndicator: ActivityIndicatorProtocol? = nil,
                                                                   activityIndicatorMessage: String? = nil,
                                                                   restOperationType: NetworkServiceRestOperationType,
                                                                   serviceBaseName: String,
                                                                   successBlock:@escaping (_ responseObject: ResponseClass) -> Void,
                                                                   errorBlock:@escaping (_ error: Error, _ validResponse: Bool) -> Void) where ResponseClass: BaseMappable
    {
        activityIndicator?.showActivityIndicator(activityIndicatorMessage)
        
        // creo la stringa identificativa del servizio
        let serviceName = "service." + restOperationType.rawValue.lowercased() + "." + serviceBaseName // + "." + self.enableSuccessMock.string
        
        // carico il Json della response, col nome corretto in base al enableSuccessMock
        guard let jsonDictionary: Dictionary<String, Any> = StorageUtils.loadJSON(name: serviceName + ".response", bundle: self.bundle) else
        {
            activityIndicator?.hideActivityIndicator()
            
            errorBlock(SystemUtils.createNSError(message: "Error loading success mock response"), true)
            return
        }
        
        // converto con objectMapper
        guard let jsonObject: ResponseClass = self.objectDecode(jsonDictionary) else
        {
            activityIndicator?.hideActivityIndicator()
            
            errorBlock(SystemUtils.createNSError(message: "Error converting \(ResponseClass.self) object"), true)
            return
        }
        
        // in base a enableSuccessMock, ritorno il blocco corrispondente
        if (self.enableSuccessMock == true)
        {
            SystemUtils.delay(milliseconds: self.responseDelay.double)
            {
                activityIndicator?.hideActivityIndicator()
                
                successBlock(jsonObject)
            }
        }
        else
        {
            SystemUtils.delay(milliseconds: self.responseDelay.double)
            {
                activityIndicator?.hideActivityIndicator()
                
                errorBlock(SystemUtils.createNSError(message: "Error: loaded failure mock response"), true)
            }
        }
    }
    
    //--------------------------------------------------------------
    fileprivate func objectDecode<ResponseClass: BaseMappable>(_ jsonDictionary: Dictionary<String, Any>) -> ResponseClass?
    {
        // converto con objectMapper
        let jsonObject = Mapper<ResponseClass>().map(JSON: jsonDictionary)
        
        return jsonObject
    }
}
