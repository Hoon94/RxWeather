//
//  ForecastTableViewCell.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/9/24.
//

import SnapKit
import Then
import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    // MARK: - Static
    
    static let identifier = "ForecastTableViewCell"
    
    // MARK: - Properties
    
    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    
    private let timeLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 14)
    }
    
    private let weatherImageView = UIImageView().then {
        $0.tintColor = .red
        $0.contentMode = .scaleAspectFit
    }
    
    private let statusLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 30)
    }
    
    private let temperatureLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 40, weight: .thin)
    }
    
    private let timeStackView = UIStackView().then {
        $0.spacing = 8
        $0.axis = .vertical
    }
    
    private let contentStackView = UIStackView().then {
        $0.spacing = 8
        $0.axis = .horizontal
        $0.alignment = .center
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
    
    func configure(from data: WeatherDataType, dateFormatter: DateFormatter, tempFormatter: NumberFormatter) {
        dateFormatter.dateFormat = "M.d (E)"
        dateLabel.text = dateFormatter.string(for: data.date)
        
        dateFormatter.dateFormat = "HH:00"
        timeLabel.text = dateFormatter.string(for: data.date)
        
        weatherImageView.image = UIImage.from(name: data.icon)
        
        statusLabel.text = data.description
        
        temperatureLabel.text = "\(tempFormatter.string(for: data.temperature) ?? "-")º"
    }
    
    private func configureLayout() {
        backgroundColor = .clear
        
        contentView.addSubview(contentStackView)
        
        timeStackView.addArrangedSubview(dateLabel)
        timeStackView.addArrangedSubview(timeLabel)
        
        contentStackView.addArrangedSubview(timeStackView)
        contentStackView.addArrangedSubview(UIView())
        contentStackView.addArrangedSubview(weatherImageView)
        contentStackView.addArrangedSubview(statusLabel)
        contentStackView.addArrangedSubview(temperatureLabel)
        
        weatherImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
}

// MARK: - Preview

#Preview {
    let mock = SampleData()
    
    let cell = ForecastTableViewCell(style: .default, reuseIdentifier: ForecastTableViewCell.identifier)
    cell.configure(from: mock, dateFormatter: MainViewModel.dateFormatter, tempFormatter: MainViewModel.tempFormatter)
    
    return cell
}
