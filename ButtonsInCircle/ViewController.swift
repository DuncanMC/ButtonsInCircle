//
//  ViewController.swift
//  ButtonsInCircle
//
//  Created by Duncan Champney on 2/28/21.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonContainerView: UIView!

    let buttonCount = 12 //The number of buttons to create
    var angleStep: Double = 0 //The change in angle between buttons

    var radius: CGFloat = 75.0  // The radius to use (will be updated at runtime based on the size of the container view.)

    //A type to hold a layout anchor for a button, it's index, and whether it's a horizontal or veritical anchor
    typealias ConstraintTuple = (index: Int, anchor: NSLayoutConstraint, axis: NSLayoutConstraint.Axis)

    //An array of the layout anchors for our buttons.
    var constraints = [ConstraintTuple]()

    //Our layout has changed. Update the array of layout anchors
    func updateButtonConstraints() {

            for (index, constraint, axis) in self.constraints {
                let angle = Double(index) * self.angleStep
                let xOffset = self.radius * CGFloat(cos(angle))
                let yOffset = self.radius * CGFloat(sin(angle))
                if axis == .horizontal {
                    constraint.constant = xOffset
                } else {
                    constraint.constant = yOffset
                }
            }
    }

    override func viewDidLayoutSubviews() {
        //Pick a radius that's a little less than 1/2 the shortest side of our bounding rectangle
        radius = min(buttonContainerView.bounds.width, buttonContainerView.bounds.height) / 2 - 30
        print("Radius = \(radius)")
        updateButtonConstraints()
    }

    func createButtons() {
        for index in 0 ..< buttonCount {

            //Create a button
            let button = UIButton(primaryAction:
                                    //Define the button title, and the action to trigger when it's tapped.
                                    UIAction(title: "Button \(index+1)") { action in
                                        print("Button \(index + 1) tapped")
                                    }
            )
            button.translatesAutoresizingMaskIntoConstraints = false //Remember to do this for UIViews you create in code
            button.layer.borderWidth = 1.0  // Draw a rounded rect around the button so you can see it
            button.layer.cornerRadius = 5

            button.setTitle("\(index+1)", for: .normal)
            button.setTitleColor(.blue, for: .normal)

            //Add it to the container view
            buttonContainerView.addSubview(button)
            button.sizeToFit()

            //Create center x & y layout anchors (with no offset to start)
            let buttonXAnchor = button.centerXAnchor.constraint(equalTo: buttonContainerView.centerXAnchor, constant: 0)
            buttonXAnchor.isActive = true

            //Add a tuple for this layout anchor to our array
            constraints.append(ConstraintTuple(index: index, anchor: buttonXAnchor, axis: .horizontal))

            let buttonYAnchor =  button.centerYAnchor.constraint(equalTo: buttonContainerView.centerYAnchor, constant: 0)
            buttonYAnchor.isActive = true

            //Add a tuple for this layout anchor to our array
            constraints.append(ConstraintTuple(index: index, anchor: buttonYAnchor, axis: .vertical))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        angleStep = Double.pi * 2.0 / Double(buttonCount)
        createButtons()
    }


}

