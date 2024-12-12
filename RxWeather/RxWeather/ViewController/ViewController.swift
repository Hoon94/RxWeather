//
//  ViewController.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/9/24.
//

import NSObject_Rx
import RxDataSources
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
        $0.font = .systemFont(ofSize: 20)
    }
    
    private let listTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.register(SummaryTableViewCell.self, forCellReuseIdentifier: SummaryTableViewCell.identifier)
        $0.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private let dataSource: RxTableViewSectionedAnimatedDataSource<SectionModel> = {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionModel> { (dataSource, tableView, indexPath, data) -> UITableViewCell in
            switch indexPath.section {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.identifier, for: indexPath) as? SummaryTableViewCell else { return UITableViewCell() }
                
                cell.configure(from: data, tempFormatter: MainViewModel.tempFormatter)
                
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as? ForecastTableViewCell else { return UITableViewCell() }
                
                cell.configure(from: data, dateFormatter: MainViewModel.dateFormatter, tempFormatter: MainViewModel.tempFormatter)
                
                return cell
            }
        }
        
        return dataSource
    }()
    
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
        viewModel.title
            .bind(to: locationLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel.weatherData
            .drive(listTableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
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
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Preview

#Preview {
    ViewController(location: "서울")
}
