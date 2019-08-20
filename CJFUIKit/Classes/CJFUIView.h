//
//  CJFUIView.h
//  CJFUIKit
//
//  Created by cjf on 2019/8/20.
//  Copyright © 2019 cjf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJFUIView : UIView

/**
 CJF - 清除所有子视图
 */
- (void)clearAllSubviews;

/**
 CJF - 获取view当前所在的控制器
 
 @return 控制器对象
 */
- (UIViewController * _Nullable)viewController;

@end

@interface CJFUIView (CJFFrame)
    
@property (nonatomic, assign) CGFloat x;      /**< CJF - 获取UIView对象的origin.x的值 */
@property (assign, nonatomic) CGFloat y;      /**< CJF - 获取UIView对象的origin.y的值 */
@property (assign, nonatomic) CGFloat width;  /**< CJF - 获取UIView对象的size.width的值 */
@property (assign, nonatomic) CGFloat height; /**< CJF - 获取UIView对象的size.height的值 */
@property (assign, nonatomic) CGPoint origin; /**< CJF - 获取UIView对象的origin的值 */
@property (assign, nonatomic) CGSize size;    /**< CJF - 获取UIView对象的size的值 */

@end

@interface CJFUIView (CJFScreenshot)
    
/**
 CJF - 应用于UIView截图
 
 @return UIImage对象
 */
- (UIImage *)screenshot;

/**
 CJF - 应用于UIScrollView截图 contentOffset
 
 @param contentOffset 内容显示区域
 @return UIImage对象
 */
- (UIImage *)screenshotForScrollViewWithContentOffset:(CGPoint)contentOffset;

/**
 CJF - 应用于UIView按Rect截图
 
 @param frame 截图区域
 @return UIImage对象
 */
- (UIImage *)screenshotInFrame:(CGRect)frame;

@end


@interface CJFUIView (CJFBadge)
    
/**
 小红点
 */
@property (nonatomic, strong) UILabel *badge;

/**
 显示小红点
 */
- (void)showBadge;

/**
 显示小红点
 
 @param number 数量
 */
- (void)showBadge:(NSInteger)number;

/**
 隐藏小红点
 */
- (void)hideBadge;
    
@end

typedef NS_OPTIONS(NSInteger, RITLBorderDirection){
    RITLBorderDirectionLeft = 1 << 1,
    RITLBorderDirectionTop = 1 << 2,
    RITLBorderDirectionRight = 1 << 3,
    RITLBorderDirectionBottom = 1 << 4,
};

/// 单边设置border
@interface CJFUIView (RITLBorder)
    
#pragma mark - 追加边框,使用默认前请优先设置默认使用的属性
    
// 使用layer的borderWidth统一设置
- (void)ritl_addBorderWithInset:(UIEdgeInsets)inset
                      Color:(UIColor *)borderColor
                  direction:(RITLBorderDirection)directions;

// 使用layer的borderColor统一设置
- (void)ritl_addBorderWithInset:(UIEdgeInsets)inset
                BorderWidth:(CGFloat)borderWidth
                  direction:(RITLBorderDirection)directions;


// 各项的间距为UIEdgeInsetsZero
- (void)ritl_addBorderWithColor:(UIColor *)borderColor
                BodrerWidth:(CGFloat)borderWidth
                  direction:(RITLBorderDirection)directions;

// 自定义的layer设置
- (void)ritl_addBorderWithInset:(UIEdgeInsets)inset
                      Color:(UIColor *)borderColor
                BorderWidth:(CGFloat)borderWidth
                  direction:(RITLBorderDirection)directions;

// 移除当前边框
- (void)ritl_removeBorders:(RITLBorderDirection)directions;

// 移除所有追加的边框
- (void)ritl_removeAllBorders;

@end

NS_ASSUME_NONNULL_END
