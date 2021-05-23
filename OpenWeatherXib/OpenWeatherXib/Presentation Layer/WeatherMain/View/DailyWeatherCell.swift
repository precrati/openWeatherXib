//
//  dailyWeatherCell.swift
//  OpenWeatherXib
//
//  Created by Igor Lemeshevski on 19/05/2021.
//

import UIKit

class DailyWeatherCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func createTime(_ timeStamp: Int) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.locale = Locale(identifier: "ru_RU")
        dayTimePeriodFormatter.dateFormat = "EEEE"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)

        return dateString
    }
    
    func configure(data: Daily) {
        
        self.dayLabel.text = createTime(data.dt)
        self.tempLabel.text = "\(Int(data.temp.day))°"
    }
}

