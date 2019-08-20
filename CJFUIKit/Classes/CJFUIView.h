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
 CJF - 获取视图所在的控制器
 
 @return 控制器对象
 */
- (UIViewController * _Nullable)viewController;

@end

NS_ASSUME_NONNULL_END
