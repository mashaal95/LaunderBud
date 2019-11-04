import UIKit


@IBDesignable class DottedVertical: UIView {
    
    @IBInspectable var dotColor: UIColor = UIColor(red: 224.0/255.0, green: 242.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    @IBInspectable var lowerHalfOnly: Bool = false
    
    override func draw(_ rect: CGRect) {
        
        // say you want 8 dots, with perfect fenceposting:
        let totalCount = 8 + 8 - 1
        let fullHeight = bounds.size.height
        let width = bounds.size.width
        let itemLength = fullHeight / CGFloat(totalCount)
        
        let path = UIBezierPath()
        
        let beginFromTop = CGFloat(0.0)
        let top = CGPoint(x: width/2, y: beginFromTop)
        let bottom = CGPoint(x: width/2, y: fullHeight)
        
        path.move(to: top)
        path.addLine(to: bottom)
        
        path.lineWidth = width
        
        let dashes: [CGFloat] = [itemLength, itemLength]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        
        // for ROUNDED dots, simply change to....
        //let dashes: [CGFloat] = [0.0, itemLength * 2.0]
        //path.lineCapStyle = CGLineCap.round
        
        dotColor.setStroke()
        path.stroke()
    }
}
