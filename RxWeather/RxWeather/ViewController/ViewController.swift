//
//  ViewController.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/9/24.
//

import SnapKit
import Then
import UIKit

class ViewController: UIViewController, ViewModelBindableType {
    
    // MARK: - Properties
    
    var viewModel: MainViewModel!
    
    private var topInset: CGFloat = 0.0
    
    private let backgroundImage = UIImageView(image: .background)
    
    private let locationLabel = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .preferredFont(forTextStyle: .largeTitle)
    }
    
    private let listTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    // MARK: - Lifecycle
    
    convenience init(location: String) {
        self.init(nibName: nil, bundle: nil)
        locationLabel.text = location
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        configureLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if topInset == 0.0 {
            let first = IndexPath(row: 0, section: 0)
            
            if let cell = listTableView.cellForRow(at: first) {
                topInset = listTableView.frame.height - cell.frame.height
                listTableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    // MARK: - Helpers
    
    func bindViewModel() {
        
    }
    
    private func configureLayout() {
        view.addSubview(backgroundImage)
        
        backgroundImage.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
        view.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(locationLabel)
        contentStackView.addArrangedSubview(listTableView)
        
        contentStackView.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }
    }
}

// MARK: - Preview

#Preview {
    ViewController(location: "서울")
}
