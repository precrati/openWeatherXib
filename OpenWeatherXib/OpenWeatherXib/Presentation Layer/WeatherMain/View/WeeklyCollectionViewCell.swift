//
//  DailyCollectionViewCell.swift
//  OpenWeatherXib
//
//  Created by Igor Lemeshevski on 19/05/2021.
//

import UIKit

class WeeklyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func secondsToHoursMinutesSeconds(seconds : Int) -> String {
      return String((seconds % 3600) / 60)
    }
//    MMM dd YYYY hh:mm a
    func createTime(_ timeStamp: Int) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.locale = Locale(identifier: "ru_RU")
        dayTimePeriodFormatter.dateFormat = "HH:mm"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)

        return dateString
    }
    
    func configure(data: Hourly) {
        self.dayLabel.text = createTime(data.dt)
        self.tempLabel.text = "\(Int(data.temp))°"
    }

}
