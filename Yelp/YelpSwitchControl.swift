//
//  YelpSwitchControl.swift
//  Yelp
//
//  Created by chengyin_liu on 5/26/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

protocol YelpSwitchControlDelegate: class {
  func yelpSwitchControl(yelpSwitchControl: YelpSwitchControl, didChangeValue on: Bool)
}

private let SWITCH_WIDTH = 70.0
private let SWITCH_HEIGHT = 30.0
private let SWITCH_PADDING = 1.5

private let SWITCH_KNOB_SIZE = SWITCH_HEIGHT - SWITCH_PADDING * 2

private let SWITCH_LABEL_WIDTH = 37.0
private let SWITCH_LABEL_HEIGHT = SWITCH_HEIGHT - SWITCH_PADDING * 2

private let SWITCH_TINT_COLOR_OFF = UIColor(red:0.79, green:0.80, blue:0.77, alpha:1.00)
private let SWITCH_TINT_COLOR_ON = UIColor.yelpCyanColor()

private let SWITCH_KNOB_FRAME_OFF = CGRect(x: SWITCH_PADDING, y: SWITCH_PADDING, width: SWITCH_KNOB_SIZE, height: SWITCH_KNOB_SIZE)
private let SWITCH_KNOB_FRAME_ON = CGRect(x: SWITCH_WIDTH - SWITCH_PADDING - SWITCH_KNOB_SIZE, y: SWITCH_PADDING, width: SWITCH_KNOB_SIZE, height: SWITCH_KNOB_SIZE)

private let SWITCH_OFF_LABEL_FRAME_OFF = CGRect(x: SWITCH_PADDING + SWITCH_KNOB_SIZE, y: SWITCH_PADDING, width: SWITCH_LABEL_WIDTH, height: SWITCH_LABEL_HEIGHT)
private let SWITCH_OFF_LABEL_FRAME_ON = CGRect(x: SWITCH_WIDTH, y: SWITCH_PADDING, width: SWITCH_LABEL_WIDTH, height: SWITCH_LABEL_HEIGHT)
private let SWITCH_ON_LABEL_FRAME_OFF = CGRect(x: 0 - SWITCH_LABEL_WIDTH , y: SWITCH_PADDING, width: SWITCH_LABEL_WIDTH, height: SWITCH_LABEL_HEIGHT)
private let SWITCH_ON_LABEL_FRAME_ON = CGRect(x: SWITCH_WIDTH - SWITCH_KNOB_SIZE - SWITCH_LABEL_WIDTH , y: SWITCH_PADDING, width: SWITCH_LABEL_WIDTH, height: SWITCH_LABEL_HEIGHT)


class YelpSwitchControl: UIView {
  var backgroundView: UIView!
  var knobView: UIImageView!
  var offLabelView: UILabel!
  var onLabelView: UILabel!

  var on: Bool = false {
    didSet {
      UIView.animateWithDuration(0.2) {
        self.layoutSubviews()
      }
    }
  }

  weak var delegate: YelpSwitchControlDelegate?

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    let frame = CGRect(x: 0, y: 0, width: SWITCH_WIDTH, height: SWITCH_HEIGHT)
    backgroundView = UIView(frame: frame)
    backgroundView.layer.cornerRadius = CGFloat(SWITCH_HEIGHT) / 2.0
    self.addSubview(backgroundView)

    knobView = UIImageView(frame: SWITCH_KNOB_FRAME_OFF)
    knobView.image = UIImage(named: "yelp-knob")
    self.addSubview(knobView)

    offLabelView = UILabel(frame: SWITCH_OFF_LABEL_FRAME_OFF)
    offLabelView.text = "OFF"
    offLabelView.textColor = UIColor.whiteColor()
    offLabelView.font = UIFont.boldSystemFontOfSize(10)
    offLabelView.textAlignment = .Center
    self.addSubview(offLabelView)

    onLabelView = UILabel(frame: SWITCH_ON_LABEL_FRAME_OFF)
    onLabelView.text = "ON"
    onLabelView.textColor = UIColor.whiteColor()
    onLabelView.font = UIFont.boldSystemFontOfSize(10)
    onLabelView.textAlignment = .Center
    self.addSubview(onLabelView)

    let recognizer = UITapGestureRecognizer.init(target: self, action: #selector(YelpSwitchControl.handleSingleTapFromRecognizer(_:)))

    self.addGestureRecognizer(recognizer)
  }

  override func intrinsicContentSize() -> CGSize {
    return CGSize(width: SWITCH_WIDTH, height: SWITCH_HEIGHT)
  }

  override func layoutSubviews() {
    backgroundView.backgroundColor =
      on ? SWITCH_TINT_COLOR_ON : SWITCH_TINT_COLOR_OFF
    knobView.frame =
      on ? SWITCH_KNOB_FRAME_ON : SWITCH_KNOB_FRAME_OFF
    offLabelView.frame =
      on ? SWITCH_OFF_LABEL_FRAME_ON : SWITCH_OFF_LABEL_FRAME_OFF
    onLabelView.frame =
      on ? SWITCH_ON_LABEL_FRAME_ON : SWITCH_ON_LABEL_FRAME_OFF
  }

  func handleSingleTapFromRecognizer(recognizer: UITapGestureRecognizer) {
    on = !on
    self.delegate?.yelpSwitchControl(self, didChangeValue: on)
  }

  /*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func drawRect(rect: CGRect) {
   // Drawing code
   }
   */

}
