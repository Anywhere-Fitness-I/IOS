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
  @IBOutlet private var classNameLabel: UILabel!
  @IBOutlet private var locationLabel: UILabel!
  @IBOutlet private var dateLabel: UILabel!
  @IBOutlet private var timeLabel: UILabel!
    

  func updateViews() {
    guard let course = course
      else { return }
    classNameLabel.text = course.name
    locationLabel.text = course.location
    dateLabel.text = course.date
    timeLabel.text = course.startTime
   
  }
}
