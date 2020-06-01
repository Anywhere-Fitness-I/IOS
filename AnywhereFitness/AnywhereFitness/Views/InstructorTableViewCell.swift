//
// InstructorCourseTableViewCell.swift
// AnywhereFitness
//
// Created by Enzo Jimenez-Soto on 5/27/20.
// Copyright © 2020 Bhawnish Kumar. All rights reserved.
//
import UIKit

class InstructorCourseTableViewCell: UITableViewCell {
  var backendController = BackendController.shared
  var course: Course? {
    didSet {
      updateViews()
    }
  }
  var id: Int64?
  @IBOutlet weak var classNameLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  func updateViews() {
    guard let course = course
      else { return }
    classNameLabel.text = course.name
    locationLabel.text = course.location
    dateLabel.text = course.date
    timeLabel.text = course.startTime
    
    classNameLabel.layer.borderColor = UIColor.white.cgColor
    classNameLabel.layer.borderWidth = 3.0
  }
}
