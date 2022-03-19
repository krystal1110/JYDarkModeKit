//
//  UIToolbar+JYDarkModeKit.m
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/19.
//

#import "UIToolbar+JYDarkModeKit.h"
#import "UIView+JYDatkModeKit.h"
@implementation UIToolbar (JYDarkModeKit)

- (void)jyTraitCollectionDidChange:(JYTraitCollection *)previousTraitCollection {
    
    if (@available(iOS 13, *)){return;}
    
    [self jy_updateDynamicColors];
}

@end
