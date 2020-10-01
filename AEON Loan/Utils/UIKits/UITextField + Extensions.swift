//
//  UITextField + Extensions.swift
//  AEON Loan
//
//  Created by aeon on 10/1/20.
//

import UIKit.UITextField
import AVFoundation

extension UITextField {
    func validatedText(type validationType: ValidatorType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)
//        return try validator.validated(self.text!)
        return try validator.validated(self.text!, self)
    }
}


// animation
extension UIView {
    func bounce() {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.beginFromCurrentState, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    func buzz(duration: Double = 0.08, repeatCount: Float = 2, vibrated: Bool = true) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration //0.05
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5.0, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5.0, y: self.center.y))
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        layer.add(animation, forKey: "position")
    }
}
