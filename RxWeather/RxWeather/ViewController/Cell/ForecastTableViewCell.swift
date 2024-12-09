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
    
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let weatherImageView = UIImageView()
    private let statusLabel = UILabel()
    private let temperatureLabel = UILabel()
    
    private let timeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
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
        contentView.addSubview(contentStackView)
        
        timeStackView.addArrangedSubview(dateLabel)
        timeStackView.addArrangedSubview(timeLabel)
        
        contentStackView.addArrangedSubview(timeStackView)
        contentStackView.addArrangedSubview(UIView())
        contentStackView.addArrangedSubview(weatherImageView)
        contentStackView.addArrangedSubview(statusLabel)
        contentStackView.addArrangedSubview(temperatureLabel)
        
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
