//
//  BaseRequest.swift
//  SearchFilterList
//
//  Created by Infotech Solutions on 22/11/21.
//

import Foundation

public protocol BaseRequest {
    associatedtype DataResponse: Decodable
}

extension BaseRequest {
    public func request<T: Encodable>(_ method: HTTPMethod, path: String, pathParams: [String: String]? = nil, body: T? = nil, broadcastUnauthorized: Bool = true, completion: @escaping (BaseResult<DataResponse>) -> ()) {
        let baseURL = APIConfig.shared.baseURL
        let token = APIConfig.shared.token
        let url = baseURL + path
        var components = URLComponents(string: url)!
        if(pathParams != nil) {
            components.queryItems = pathParams!.map({ URLQueryItem(name: $0, value: $1) })
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url: components.url!,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: 200)
        request.httpMethod = method.rawValue
        if(!(token ?? "").isEmpty) {
            request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        }
        if let dataBody = body {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let requestData = try? JSONEncoder().encode(dataBody)
            request.httpBody = requestData
        }
        #if DEBUG
        print("debug- Request URL: \(request.url!)")
        
        #endif
        let customTrust = SSLCustomTrust()
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: customTrust, delegateQueue: nil)
        session.dataTask(with: request) { data, response, error in
            if error != nil || response == nil {
                completion(BaseResult(status: false, data: nil, message:
                "Can't connect to server"))
            } else {
                let httpResponse = response as! HTTPURLResponse
                let strResponse = String(data: data!, encoding: .utf8)
                #if DEBUG
                    print("debug- Response : \(strResponse!)")
                #endif
                if data != nil {
                    var decoded: Any? = nil
                    do {
                        decoded = try JSONDecoder().decode(BaseResponse<DataResponse>.self, from: data!) as BaseResponse<DataResponse>
                    } catch {
                        
                        do {
                            decoded = try JSONDecoder().decode(DataResponse.self, from: data!) as DataResponse
                        } catch {}
                    }
                    if httpResponse.statusCode >= 200 && httpResponse.statusCode <= 300 {
                        print("masuk -")
                        if let res = decoded as? BaseResponse<DataResponse> {
                            print("masuk - \(res.status) \(res.message)")
                            completion(BaseResult<DataResponse>(status: true, data: res.data, message: ""))
                        } else if let res = decoded as? DataResponse {
                            completion(BaseResult<DataResponse>(status: true, data: res, message: ""))
                        }
                    } else {
                        
                        if httpResponse.statusCode == 400 {
                            var errorMsg = "Bad Request"
                            do {
                                let APIData  = try JSONDecoder().decode(ErrorResponse.self, from: data!)
                                errorMsg = APIData.message
                            } catch {}
                            
                            completion(BaseResult(status: false, data: nil, message: errorMsg))
                            return
                        }
                        if httpResponse.statusCode == 408 {
                            completion(BaseResult(status: false, data: nil, message: "Request Timeout"))
                            return
                        }
                        
                        if httpResponse.statusCode == 401 && broadcastUnauthorized {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Unauthorized Access"), object: nil)
                            return
                        }
                        
                        if httpResponse.statusCode == 500 {
                            completion(BaseResult(status: false, data: nil, message: "Internal Server Error"))
                            return
                        }
                        
                        completion(BaseResult(status: false, data: nil, message: "Something need to be fixed"))
                    }
                } else {
                    completion(BaseResult(status: false, data: nil, message: "Something need to be fixed"))
                }
            }
            
        }.resume()
    }
    
    public func request(_ method: HTTPMethod, path: String, pathParams: [String: String]? = nil, broadcastUnauthorized: Bool = true, completion: @escaping (BaseResult<DataResponse>) -> ()) {
        let baseURL = APIConfig.shared.baseURL
        let token = APIConfig.shared.token
        let url = baseURL + path
        var components = URLComponents(string: url)!
        if(pathParams != nil) {
            components.queryItems = pathParams!.map({ URLQueryItem(name: $0, value: $1) })
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url: components.url!,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: 200)
        request.httpMethod = method.rawValue
        request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        #if DEBUG
        print("debug- Request URL: \(request.url!)")
        #endif
        let customTrust = SSLCustomTrust()
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: customTrust, delegateQueue: nil)
        session.dataTask(with: request) { data, response, error in
            if error != nil || response == nil {
                completion(BaseResult(status: false, data: nil, message:
                "Can't connect to server"))
            } else {
                let httpResponse = response as! HTTPURLResponse
                let strResponse = String(data: data!, encoding: .utf8)
                #if DEBUG
                print("debug- Response : \(strResponse!)")
                #endif
                if data != nil {
                    var decoded: Any? = nil
                    do {
                        decoded = try JSONDecoder().decode(BaseResponse<DataResponse>.self, from: data!) as BaseResponse<DataResponse>
                    } catch {
                        do {
                            decoded = try JSONDecoder().decode(DataResponse.self, from: data!) as DataResponse
                        } catch {
                            
                        }
                    }
                    if httpResponse.statusCode >= 200 && httpResponse.statusCode <= 300 {
                        if let res = decoded as? BaseResponse<DataResponse> {
                            if res.status == true {
                                print("masuk - \(res.status)")
                                completion(BaseResult<DataResponse>(status: true, data: res.data, message: res.message))
                            } else {
                                completion(BaseResult<DataResponse>(status: true, data: nil, message: res.message))
                            }
                            
                        } else if let res = decoded as? DataResponse {
                            print("decided dataresponse")
                            dump(res)
                            completion(BaseResult<DataResponse>(status: true, data: res, message: ""))
                        }
                    } else {
                        
                        if httpResponse.statusCode == 400 {
                            var errorMsg = "Bad Request"
                            do {
                                let APIData  = try JSONDecoder().decode(ErrorResponse.self, from: data!)
                                errorMsg = APIData.message
                            } catch {}
                            
                            completion(BaseResult(status: false, data: nil, message: errorMsg))
                            return
                        }
                            
                        if httpResponse.statusCode == 408 {
                            completion(BaseResult(status: false, data: nil, message: "Request Timeout"))
                            return
                        }
                        
                        if httpResponse.statusCode == 401 && broadcastUnauthorized {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Unauthorized Access"), object: nil)
                            return
                        }
                        
                        if httpResponse.statusCode == 500 {
                            completion(BaseResult(status: false, data: nil, message: "Internal Server Error"))
                            return
                        }
                        
                        completion(BaseResult(status: false, data: nil, message: "Something need to be fixed"))
                    }
                } else {
                    completion(BaseResult(status: false, data: nil, message: "Something need to be fixed"))
                }
            }
            
        }.resume()
    }
}

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
}

class SSLCustomTrust: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}
