//
//  SummaryTableViewCell.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/9/24.
//

import SnapKit
import Then
import UIKit

class SummaryTableViewCell: UITableViewCell {
    
    // MARK: - Static
    
    static let identifier = "SummaryTableViewCell"
    
    // MARK: - Properties
    
    private let weatherImageView = UIImageView().then {
        $0.tintColor = .red
        $0.contentMode = .scaleAspectFit
    }
    
    private let statusLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 30)
    }
    
    private let minMaxLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17)
    }
    
    private let currentTemperatureLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 100, weight: .ultraLight)
    }
    
    private let weatherStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    private let contentStackView = UIStackView().then {
        $0.spacing = 8
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure(from data: WeatherDataType, tempFormatter: NumberFormatter) {
        weatherImageView.image = UIImage.from(name: data.icon)
        statusLabel.text = data.description
        
        let max = data.maxTemperature ?? 0.0
        let min = data.minTemperature ?? 0.0
        
        minMaxLabel.text = "최대 \(tempFormatter.string(for: max) ?? "-")º 최소 \(tempFormatter.string(for: min) ?? "-")º"
        
        currentTemperatureLabel.text = "\(tempFormatter.string(for: data.temperature) ?? "-")º"
    }
    
    private func configureLayout() {
        backgroundColor = .clear
        
        contentView.addSubview(contentStackView)
        
        weatherStackView.addArrangedSubview(weatherImageView)
        weatherStackView.addArrangedSubview(statusLabel)
        
        weatherImageView.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
        
        contentStackView.addArrangedSubview(weatherStackView)
        contentStackView.addArrangedSubview(minMaxLabel)
        contentStackView.addArrangedSubview(currentTemperatureLabel)
        
        contentStackView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
}

// MARK: - Preview

#Preview {
    let mock = SampleData()
    
    let cell = SummaryTableViewCell(style: .default, reuseIdentifier: SummaryTableViewCell.identifier)
    cell.configure(from: mock, tempFormatter: MainViewModel.tempFormatter)
    
    return cell
}
