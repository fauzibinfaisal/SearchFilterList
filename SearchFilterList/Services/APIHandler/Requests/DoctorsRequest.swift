//
//  DoctorsRequest.swift
//  SearchFilterList
//
//  Created by Infotech Solutions on 22/11/21.
//

import Foundation

class DoctorsRequest: BaseRequest {
    
    typealias DataResponse = BaseResponse<[Doctor]>
    
    func getDoctorLists(completion: @escaping(BaseResult<DataResponse>) -> Void) {
        let path = "v3/\(Secrets.API_KEY)"
        
        request(.GET, path: path) { (result) in
            completion(result)
        }
    }
    
}
