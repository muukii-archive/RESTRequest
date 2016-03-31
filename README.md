# RESTRequest

[![CI Status](http://img.shields.io/travis/muukii/RESTRequest.svg?style=flat)](https://travis-ci.org/muukii/RESTRequest)
[![Version](https://img.shields.io/cocoapods/v/RESTRequest.svg?style=flat)](http://cocoapods.org/pods/RESTRequest)
[![License](https://img.shields.io/cocoapods/l/RESTRequest.svg?style=flat)](http://cocoapods.org/pods/RESTRequest)
[![Platform](https://img.shields.io/cocoapods/p/RESTRequest.svg?style=flat)](http://cocoapods.org/pods/RESTRequest)

Example usage of [BrickRequest](https://github.com/muukii/BrickRequest).

RESTRequest's dependencies.
- BrickRequest (Good architecture for Alamofire)
- Alamofire (Request core)
- RxSwift (Dispatch, AutoRetry with reachability)
- SwiftyJSON (Response, Request parameters)

## Usage

### Define Requests
- GET
```swift
struct GetUsers: GETRequestType {
  var path: String {
    return "/user"
  }

  var parameterJSON: JSON {
    let json = JSON([
      "limit" : 10,
      "page" : 1,
    ])
    return json
  }
}
```

### Dispatch Requests
```swift
let context = GetUsers()
_ = context.resume().subscribeNext { json in
    // response
}
```

## Requirements

## Installation

RESTRequest is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "RESTRequest"
```

## Author

muukii, m@muukii.me

## License

RESTRequest is available under the MIT license. See the LICENSE file for more info.
