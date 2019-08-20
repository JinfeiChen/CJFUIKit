//
//  CJFUIView.m
//  CJFUIKit
//
//  Created by cjf on 2019/8/20.
//  Copyright © 2019 cjf. All rights reserved.
//

#import "CJFUIView.h"

@implementation CJFUIView

- (void)clearAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (UIViewController *)viewController
{
    UIViewController *viewController = nil;
    UIResponder *next = self.nextResponder;
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController *)next;
            break;
        }
        next = next.nextResponder;
    }
    return viewController;
}

@end



@implementation CJFUIView (CJFFrame)
    
#pragma mark - Setter
    
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
    
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
    
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
    
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
    
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
    
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
    
#pragma mark - Getter
    
- (CGFloat)x {
    return self.frame.origin.x;
}
    
- (CGFloat)y {
    return self.frame.origin.y;
}
    
- (CGFloat)width {
    return self.frame.size.width;
}
    
- (CGFloat)height {
    return self.frame.size.height;
}
    
- (CGPoint)origin {
    return self.frame.origin;
}
    
- (CGSize)size {
    return self.frame.size;
}
    
@end



@implementation CJFUIView (CJFScreenshot)
    
- (UIImage *)screenshot {
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    image = [UIImage imageWithData:imageData];
    
    return image;
}
    
- (UIImage *)screenshotForScrollViewWithContentOffset: (CGPoint)contentOffset {
    
    UIGraphicsBeginImageContext(self.bounds.size);
    //need to translate the context down to the current visible portion of the scrollview
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, -contentOffset.y);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.55);
    image = [UIImage imageWithData:imageData];
    
    return image;
}
    
- (UIImage *)screenshotInFrame: (CGRect)frame {
    
    UIGraphicsBeginImageContext(frame.size);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), frame.origin.x, frame.origin.y);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
}
    
@end

#import <objc/runtime.h>

static char badgeKey;
static CGFloat const badgeRadius = 6.0f; /**< 小红点半径 */
static CGFloat const badgeMargin = 5.0f; /**< 小红点外边距 */
static CGFloat const badgeFontSize = 9.0f; /**< 小红点字体大小 */

@implementation CJFUIView (CJFBadge)
    
- (void)showBadge
{
    if (!self.badge) {
        CGRect frame = CGRectMake(CGRectGetWidth(self.frame) - badgeMargin - badgeRadius, badgeMargin, badgeRadius, badgeRadius);
        self.badge = [[UILabel alloc] initWithFrame:frame];
        self.badge.backgroundColor = [UIColor redColor];
        self.badge.layer.cornerRadius = badgeRadius / 2;
        self.badge.layer.masksToBounds = YES;
        [self addSubview:self.badge];
        [self bringSubviewToFront:self.badge];
    }
}

- (void)showBadge:(NSInteger)number
{
    if (number <= 0) {
        return;
    }
    
    [self showBadge];
    
    self.badge.textColor = [UIColor whiteColor];
    self.badge.font = [UIFont systemFontOfSize:badgeFontSize];
    self.badge.textAlignment = NSTextAlignmentCenter;
    self.badge.text = [NSString stringWithFormat:@"%ld", (long)number];
    [self.badge sizeToFit];
    CGRect frame = self.badge.frame;
    frame.size.width += 4.f;
    frame.size.height += 4.f;
    frame.origin.y = -(frame.size.height / 2);
    if (CGRectGetWidth(frame) < CGRectGetHeight(frame)) {
        frame.size.width = CGRectGetHeight(frame);
    }
    self.badge.frame = frame;
    self.badge.layer.cornerRadius = CGRectGetHeight(self.badge.frame) / 2;
}

- (void)hideBadge
{
    [self.badge removeFromSuperview];
    self.badge = nil;
}

#pragma mark - Getter

- (UILabel *)badge
{
    return objc_getAssociatedObject(self, &badgeKey);
}

- (void)setBadge:(UILabel *)badge
{
    objc_setAssociatedObject(self, &badgeKey, badge, OBJC_ASSOCIATION_RETAIN);
}

@end


#pragma mark - RITLBorderLayer

@interface RITLBorderLayer: CALayer

/// 默认为0.0
@property (nonatomic, assign)CGFloat ritl_borderWidth;
/// 默认为UIEdgeInsetsZero
@property (nonatomic, assign)UIEdgeInsets ritl_borderInset;

@end

@implementation RITLBorderLayer

- (instancetype)init
{
    if (self = [super init]) {
        
        self.anchorPoint = CGPointZero;
        self.ritl_borderWidth = 0.0;
        self.ritl_borderInset = UIEdgeInsetsZero;
    }
    
    return self;
}

@end


#pragma mark - <RITLViewBorderDirection>

@protocol RITLViewBorderDirection <NSObject>

@property (nonatomic, strong) RITLBorderLayer *leftLayer;
@property (nonatomic, strong) RITLBorderLayer *topLayer;
@property (nonatomic, strong) RITLBorderLayer *rightLayer;
@property (nonatomic, strong) RITLBorderLayer *bottomLayer;

@end



#pragma mark - UIView<RITLViewBorderDirection>
@interface UIView (RITLViewBorderDirection)<RITLViewBorderDirection>
@end


#pragma mark - UIView(RITLBorder)
@implementation CJFUIView (RITLBorder)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method originMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
        Method swizzledMethod = class_getInstanceMethod(self, @selector(ritl_borderlayoutsubViews));
        
        BOOL didAddMethod = class_addMethod(self, @selector(layoutSubviews), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {//追加成功，进行替换
            
            class_replaceMethod(self,
                                @selector(layoutSubviews),
                                method_getImplementation(swizzledMethod),
                                method_getTypeEncoding(swizzledMethod));
        }else {
            
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}



- (void)ritl_borderlayoutsubViews
{
    [self ritl_borderlayoutsubViews];
    
    CGRect generalBound = self.leftLayer.bounds;
    CGPoint generalPoint = CGPointZero;
    UIEdgeInsets generalInset = self.leftLayer.ritl_borderInset;
    
    //left
    generalBound.size.height = self.layer.bounds.size.height - generalInset.top - generalInset.bottom;//高度
    generalBound.size.width = self.leftLayer.ritl_borderWidth;//宽度为border
    self.leftLayer.bounds = generalBound;
    
    generalPoint.x = generalInset.left;
    generalPoint.y = generalInset.top;
    self.leftLayer.position = generalPoint;
    
    generalBound = self.topLayer.bounds;
    generalPoint = self.topLayer.position;
    generalInset = self.topLayer.ritl_borderInset;
    
    //top
    generalBound.size.height = self.topLayer.ritl_borderWidth;
    generalBound.size.width = self.layer.bounds.size.width - generalInset.left - generalInset.right;
    self.topLayer.bounds = generalBound;
    
    generalPoint.x = generalInset.left;
    generalPoint.y = generalInset.top;
    self.topLayer.position = generalPoint;
    
    generalBound = self.rightLayer.bounds;
    generalPoint = self.rightLayer.position;
    generalInset = self.rightLayer.ritl_borderInset;
    
    //right
    generalBound.size.height = self.layer.bounds.size.height - generalInset.top - generalInset.bottom;
    generalBound.size.width = self.rightLayer.ritl_borderWidth;
    self.rightLayer.bounds = generalBound;
    
    generalPoint.x = self.layer.bounds.size.width - generalInset.right - generalBound.size.width;
    generalPoint.y = generalInset.top;
    self.rightLayer.position = generalPoint;
    
    generalBound = self.bottomLayer.bounds;
    generalPoint = self.bottomLayer.position;
    generalInset = self.bottomLayer.ritl_borderInset;
    
    //bottom
    generalBound.size.height = self.bottomLayer.ritl_borderWidth;
    generalBound.size.width = self.layer.bounds.size.width - generalInset.right - generalInset.left;
    self.bottomLayer.bounds = generalBound;
    
    generalPoint.x = generalInset.left;
    generalPoint.y = self.layer.bounds.size.height - generalInset.bottom - generalBound.size.height;
    self.bottomLayer.position = generalPoint;
}





#pragma mark - public

- (void)ritl_addBorderWithInset:(UIEdgeInsets)inset
                      Color:(UIColor *)borderColor
                  direction:(RITLBorderDirection)directions
{
    [self ritl_addBorderWithInset:inset Color:borderColor BorderWidth:self.layer.borderWidth direction:directions];
}


- (void)ritl_addBorderWithInset:(UIEdgeInsets)inset
                BorderWidth:(CGFloat)borderWidth
                  direction:(RITLBorderDirection)directions
{
    [self ritl_addBorderWithInset:inset Color:[UIColor colorWithCGColor:self.layer.borderColor] BorderWidth:borderWidth direction:directions];
}


- (void)ritl_addBorderWithColor:(UIColor *)borderColor
                BodrerWidth:(CGFloat)borderWidth
                  direction:(RITLBorderDirection)directions
{
    [self ritl_addBorderWithInset:UIEdgeInsetsZero Color:borderColor BorderWidth:borderWidth direction:directions];
}


- (void)ritl_addBorderWithInset:(UIEdgeInsets)inset
                      Color:(UIColor *)borderColor
                BorderWidth:(CGFloat)borderWidth
                  direction:(RITLBorderDirection)directions
{
    if (directions & RITLBorderDirectionLeft) {
        
        self.leftLayer.backgroundColor = borderColor.CGColor;
        self.leftLayer.ritl_borderWidth = borderWidth;
        self.leftLayer.ritl_borderInset = inset;
        if (self.leftLayer.superlayer) { [self.leftLayer removeFromSuperlayer]; }
        [self.layer addSublayer:self.leftLayer];
    }
    
    if (directions & RITLBorderDirectionTop) {
        
        self.topLayer.backgroundColor = borderColor.CGColor;
        self.topLayer.ritl_borderWidth = borderWidth;
        self.topLayer.ritl_borderInset = inset;
        if (self.topLayer.superlayer) { [self.topLayer removeFromSuperlayer]; }
        [self.layer addSublayer:self.topLayer];
    }
    
    if (directions & RITLBorderDirectionRight) {
        
        self.rightLayer.backgroundColor = borderColor.CGColor;
        self.rightLayer.ritl_borderWidth = borderWidth;
        self.rightLayer.ritl_borderInset = inset;
        if (self.rightLayer.superlayer) { [self.rightLayer removeFromSuperlayer]; }
        [self.layer addSublayer:self.rightLayer];
    }
    
    if (directions & RITLBorderDirectionBottom) {
        
        self.bottomLayer.backgroundColor = borderColor.CGColor;
        self.bottomLayer.ritl_borderWidth = borderWidth;
        self.bottomLayer.ritl_borderInset = inset;
        if (self.bottomLayer.superlayer) { [self.bottomLayer removeFromSuperlayer]; }
        [self.layer addSublayer:self.bottomLayer];
    }
    
    [self setNeedsLayout];
}



- (void)ritl_removeBorders:(RITLBorderDirection)directions
{
    if (directions & RITLBorderDirectionLeft) {
        
        [self ritl_removeBorderLayer:self.leftLayer];
    }
    
    if (directions & RITLBorderDirectionTop) {
        
        [self ritl_removeBorderLayer:self.topLayer];
    }
    
    if (directions & RITLBorderDirectionRight) {
        
        [self ritl_removeBorderLayer:self.rightLayer];
    }
    
    if (directions & RITLBorderDirectionBottom) {
        
        [self ritl_removeBorderLayer:self.bottomLayer];
    }
}

- (void)ritl_removeAllBorders
{
    [self ritl_removeBorderLayer:self.leftLayer];
    [self ritl_removeBorderLayer:self.topLayer];
    [self ritl_removeBorderLayer:self.rightLayer];
    [self ritl_removeBorderLayer:self.bottomLayer];
}



#pragma mark - private

- (void)ritl_removeBorderLayer:(CALayer *)layer
{
    if (layer) {
        
        [layer removeFromSuperlayer];
    }
}

#pragma mark - RITLViewBorderDirection


#pragma mark - layer

- (void)setLeftLayer:(RITLBorderLayer *)leftLayer
{
    objc_setAssociatedObject(self, @selector(leftLayer), leftLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTopLayer:(RITLBorderLayer *)topLayer
{
    objc_setAssociatedObject(self, @selector(topLayer), topLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setRightLayer:(RITLBorderLayer *)rightLayer
{
    objc_setAssociatedObject(self, @selector(rightLayer), rightLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setBottomLayer:(RITLBorderLayer *)bottomLayer
{
    objc_setAssociatedObject(self, @selector(bottomLayer), bottomLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (RITLBorderLayer *)leftLayer
{
    id layer = objc_getAssociatedObject(self, _cmd);
    
    if (layer == nil) {
        
        self.leftLayer = RITLBorderLayer.new;
    }
    
    return objc_getAssociatedObject(self, _cmd);
}


- (RITLBorderLayer *)topLayer
{
    id layer = objc_getAssociatedObject(self, _cmd);
    
    if (layer == nil) {
        
        self.topLayer = RITLBorderLayer.new;
    }
    
    return objc_getAssociatedObject(self, _cmd);
}


- (RITLBorderLayer *)rightLayer
{
    id layer = objc_getAssociatedObject(self, _cmd);
    
    if (layer == nil) {
        
        self.rightLayer = RITLBorderLayer.new;
    }
    
    return objc_getAssociatedObject(self, _cmd);
}


- (RITLBorderLayer *)bottomLayer
{
    id layer = objc_getAssociatedObject(self, _cmd);
    
    if (layer == nil) {
        
        self.bottomLayer = RITLBorderLayer.new;
    }
    
    return objc_getAssociatedObject(self, _cmd);
}

@end
