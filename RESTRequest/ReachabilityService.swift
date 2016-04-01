//
//  ReachabilityService.swift
//  RxExample
//
//  Created by Vodovozov Gleb on 10/22/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

#if !RX_NO_MODULE
    import RxSwift
#endif

public enum ReachabilityStatus {
    case Reachable, Unreachable
}

class ReachabilityService {
    
    private let reachabilityRef = try! Reachability.reachabilityForInternetConnection()
    
    private let _reachabilityChangedSubject = PublishSubject<ReachabilityStatus>()
    private var reachabilityChanged: Observable<ReachabilityStatus> {
        return _reachabilityChangedSubject.asObservable()
    }
    
    // singleton
    static let sharedReachabilityService = ReachabilityService()
    
    init(){
        reachabilityRef.whenReachable = { reachability in
            self._reachabilityChangedSubject.on(.Next(.Reachable))
        }
        
        reachabilityRef.whenUnreachable = { reachability in
            self._reachabilityChangedSubject.on(.Next(.Unreachable))
        }
        
        try! reachabilityRef.startNotifier()
        
    }
}

extension ObservableConvertibleType {
    func retryOnBecomesReachable(reachabilityService: ReachabilityService) -> Observable<E> {
        return self.asObservable()
            .retryWhen { (errors: Observable<ErrorType>) in
                return errors
                    .scan((0, nil)) { (a: (Int, ErrorType!), e) in
                        return (a.0 + 1, e)
                    }
                    .flatMap { retryCount, error -> Observable<Void> in
                        if case .LostConnection? = error as? RESTRequestError where retryCount < 3 {
                            return createRetryTrigger(reachabilityService)
                        }
                        return Observable.error(error)
                }
        }
    }
}

private func createRetryTrigger(reachabilityService: ReachabilityService) -> Observable<Void> {
    
    let reachable: Observable<Bool> = reachabilityService.reachabilityChanged
        .map { $0 == .Reachable }
        .startWith(reachabilityService.reachabilityRef.isReachable())
    
    let interval = Observable<Int>.interval(5, scheduler: MainScheduler.instance)
    
    let trigger = Observable.combineLatest(reachable, interval) { reachable, _ -> Bool in
        return reachable
        }
        .filter { $0 == true }
        .map { _ -> Void in }
    
    return trigger
}
