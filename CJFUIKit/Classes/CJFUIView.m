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
