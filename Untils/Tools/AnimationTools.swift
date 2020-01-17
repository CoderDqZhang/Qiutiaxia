
//
//  AnimationTools.swift
//  CatchMe
//
//  Created by Zhang on 07/12/2017.
//  Copyright © 2017 Zhang. All rights reserved.
//

import UIKit
import pop

enum TouchStatus {
    case begin
    case end
}

typealias AnimationFinishClouse = (_ ret:Bool) ->Void

class AnimationTools: NSObject {
    
    private static let _sharedInstance = AnimationTools()
    
    class func getSharedInstance() -> AnimationTools {
        return _sharedInstance
    }
    
    private override init() {} // 私有化init方法
    
    @available(iOS 9.0, *)
    func setUpAnimation(_ float:CGFloat, velocity:CGFloat, finish:@escaping AnimationFinishClouse) ->CASpringAnimation{
        let ani = CASpringAnimation.init(keyPath: "position.y")
        ani.mass = 10.0; //质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
        ani.stiffness = 1000; //刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
        ani.damping = 100.0;//阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
        ani.initialVelocity = velocity;//初始速率，动画视图的初始速度大小;速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
        ani.duration = ani.settlingDuration;
        ani.toValue = float
        ani.delegate = self
        ani.isRemovedOnCompletion = false
        ani.fillMode = CAMediaTimingFillMode.forwards;
        ani.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        _ = Timer.after(ani.settlingDuration, {
            finish(true)
        })
        return ani
    }
    
    func moveAnimation(view:UIView?,frame:CGRect,finishClouse:@escaping AnimationFinishClouse){
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            view?.frame = frame
        }) { (ret) in
            finishClouse(ret)
        }
    }
    
    func scalAnimation(view:UIView){
        let scale = POPSpringAnimation.init(propertyNamed: kPOPLayerScaleXY)
        scale?.fromValue = NSValue.init(cgSize: CGSize.init(width: 1.75, height: 1.75))
        scale?.toValue = NSValue.init(cgSize: CGSize.init(width: 1, height: 1))
        scale?.dynamicsTension = 1000
        scale?.dynamicsMass = 1.3
        scale?.dynamicsFriction = 10.3
        scale?.springSpeed = 10
        scale?.springBounciness = 15.64
        self.shakeAnimation(view: view)
//        view.layer.pop_add(scale, forKey: "scale")
    }
    
    func moveSpringAnimation(view:UIView?){
        let moveAnimation = POPSpringAnimation.init(propertyNamed: kPOPLayerPositionY)
//        moveAnimation?.velocity = 100
        moveAnimation?.autoreverses = true
        moveAnimation?.fromValue = NSValue.init(cgPoint: CGPoint.init(x: 0, y: -100))
        moveAnimation?.toValue = NSValue.init(cgPoint: CGPoint.init(x: 0, y: 100))
//        moveAnimation?.dynamicsMass = 1.3
//        moveAnimation?.springSpeed = 200
        view?.layer.pop_add(moveAnimation, forKey: "moveAnimation")
    }
    
    func shakeAnimation(view:UIView){
        let shake = CABasicAnimation.init(keyPath: "transform.rotation.z")
        shake.fromValue = 0.1
        shake.toValue = -0.1
        shake.duration = 0.1
        shake.autoreverses = false //是否重复
        shake.repeatCount = 2
        view.layer.add(shake, forKey: "transformRotation")
        view.alpha = 1.0
        UIView.animate(withDuration: 2.0, delay: 1, options: .curveEaseIn, animations: {
            
        }) { (ret) in
            
        }
    }
    
    func removeViewAnimation(view:UIView,finish:@escaping AnimationFinishClouse) {
        UIView.animate(withDuration: 0.2, animations: {
            view.alpha = 0
            view.transform = CGAffineTransform.init(scaleX: 0.75, y: 0.75)
            
        }) { (ret) in
            view.removeFromSuperview()
            finish(ret)
        }
    }
    
    func removeBigViewAnimation(view:UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            view.alpha = 0
            view.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        }) { (ret) in
            view.removeFromSuperview()
        }
    }
    
    func scalBigToNormalAnimation(view:UIView){
        view.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        }){ (ret) in
            UIView.animate(withDuration: 0.2, animations: {
                view.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
        }
    }
    
    func hiddenViewAnimation(view:UIView, frame:CGRect, finish:@escaping AnimationFinishClouse){
        for subview in view.subviews {
            subview.isHidden = true
        }
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform.identity
            view.frame = frame
        }){ (ret) in
            finish(ret)
        }
    }
    
    func showViewAnimation(view:UIView,frame:CGRect, finish:@escaping AnimationFinishClouse){
        view.transform = CGAffineTransform.identity
        for subview in view.subviews {
            subview.isHidden = false
        }
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            view.frame = frame
        }){ (ret) in
            finish(ret)
        }
    }
    
    func opacityForever_Animation() -> CABasicAnimation{
        
        let animation = CABasicAnimation.init(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.autoreverses = true
        animation.duration = 1
        animation.repeatCount =  10000000
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        return animation
    }
}

extension AnimationTools : CAAnimationDelegate {
    
}

