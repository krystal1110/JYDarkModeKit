//
//  UIImageView+JYDarkModeKit.h
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/13.
//

#import <UIKit/UIKit.h>
#import "JYDynamicImageProxy.h"
#import <objc/message.h>
#import "JYTraitCollection.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (JYDarkModeKit)<JYTraitEnvironment>
@property (nullable, readonly) JYDynamicImageProxy *jy_dynamicImage;

+ (void)jy_swizzleSetImage;

@end

NS_ASSUME_NONNULL_END
