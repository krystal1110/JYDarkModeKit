//
//  UIView+JYDatkModeKit.h
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/11.
//

#import <UIKit/UIKit.h>
#import "JYTraitCollection.h"
#import "JYDynamicColor.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JYDatkModeKit)<JYTraitEnvironment>

- (void)jy_updateDynamicColors API_DEPRECATED("jy_updateDynamicColors is deprecated and will not be called on iOS 13.0, use jyTraitCollectionDidChange: instead", ios(11.0, 13.0));;

- (void)jy_updateDynamicImages API_DEPRECATED("jy_updateDynamicImages is deprecated and will not be called on iOS 13.0, use jyTraitCollectionDidChange: instead", ios(11.0, 13.0));;

@property (nullable, readonly) JYDynamicColor *jy_dynamicBackgroundColor;
@property (nullable, readonly) JYDynamicColor *jy_dynamicTintColor;

+ (void)jy_swizzleSetBackgroundColor;
+ (void)jy_swizzleSetTintColor;

@end

NS_ASSUME_NONNULL_END
