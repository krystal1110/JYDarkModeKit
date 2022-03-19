//
//  UIColor+JYDarkModeKit.h
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/10.
//

#import <UIKit/UIKit.h>
#import "JYTraitCollection.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIColor (JYDarkModeKit)

+ (UIColor *)jy_colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor
NS_SWIFT_UNAVAILABLE("Use init(_:light:dark:) instead.");

+ (UIColor *)jy_colorWithDynamicProvider:(UIColor * (^)(JYTraitCollection *traitCollection))dynamicProvider
NS_SWIFT_UNAVAILABLE("Use init(_:dynamicProvider:) instead.");


@end

NS_ASSUME_NONNULL_END
