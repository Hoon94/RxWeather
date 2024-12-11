//
//  SceneCoordinator.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/11/24.
//

import RxSwift
import UIKit

extension UIViewController {
    var sceneViewController: UIViewController {
        return self.children.first ?? self
    }
}

class SceneCoordinator: SceneCoordinatorType {
    
    // MARK: - Properties
    
    private let bag = DisposeBag()
    private var window: UIWindow
    private var currentViewController: UIViewController
    
    // MARK: - Lifecycle
    
    required init(window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController ?? UIViewController()
    }
    
    // MARK: - Helpers
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        let subject = PublishSubject<Never>()
        
        let target = scene.instantiate()
        
        switch style {
        case .root:
            currentViewController = target.sceneViewController
            window.rootViewController = target
            subject.onCompleted()
        case .push:
            guard let navigationController = currentViewController.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            navigationController.rx.willShow
                .subscribe(onNext: { [unowned self] event in
                    self.currentViewController = event.viewController.sceneViewController
                })
                .disposed(by: bag)
            
            navigationController.pushViewController(target, animated: animated)
            currentViewController = target.sceneViewController
            
            subject.onCompleted()
        case .modal:
            currentViewController.present(target, animated: animated) {
                subject.onCompleted()
            }
            
            currentViewController = target.sceneViewController
        }
        
        return subject.asCompletable()
    }
    
    @discardableResult
    func close(animated: Bool) -> Completable {
        return Completable.create { [unowned self] completable in
            if let presentingViewController = self.currentViewController.presentingViewController {
                self.currentViewController.dismiss(animated: animated) {
                    self.currentViewController = presentingViewController.sceneViewController
                    completable(.completed)
                }
            } else if let navigationController = self.currentViewController.navigationController {
                guard navigationController.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                
                self.currentViewController = navigationController.viewControllers.last?.sceneViewController ?? UIViewController()
                completable(.completed)
            } else {
                completable(.error(TransitionError.unknown))
            }
            
            return Disposables.create()
        }
    }
}
