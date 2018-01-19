//
// Notepad
// Demo2ViewController.swift
// Created by DouKing (https://github.com/DouKing) on 2018/1/19.
// 

import UIKit
import Moya
import HandyJSON

class Demo2ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    moyaDemo()
  }

  func moyaDemo() {
    let brandProvider = MoyaProvider<BrandRequest>()
    brandProvider.request(BrandRequest()) { (result) in
      switch result {
      case let .success(value):
        let data = value.data
        let jsonString = String(data: data, encoding: .utf8)
        if let brands = JSONDeserializer<Brands>.deserializeFrom(json: jsonString) {
          if let hotBrands = brands.hotBrands {
            for brand in hotBrands {
              print("id: \(brand.brandId ?? "<null>"), name: \(brand.name ?? "<null>")")
            }
          }
        }
      case let .failure(error):
        print("error: \(error)")
      }
    }
  }
}

struct Brands: HandyJSON {
  var hotBrands: [HotBrand]?
}

struct HotBrand: HandyJSON {
  var brandId: String?
  var img: String?
  var name: String?
}

class BrandRequest: TargetType {
  var sampleData: Data {
    return Data()
  }

  var headers: [String : String]? {
    return [
      "Content-type" : "application/json",
      "Accept-Encoding" : "gzip",
      "app-ver" : "1.0",
      "platform-ver" : "10.0",
      "device-id" : "12324412313213122312",
      "product" : "0",
      "platform-type" : "0",
      "app-id" : "0",
    ]
  }

  var task: Task {
    return .requestPlain
  }

  var baseURL: URL {
    return URL(string: "https://las.secoo.com")!
  }

  var path: String {
    return "api/category/all_hot_brands"
  }

  var method: Moya.Method {
    return .get
  }
}
