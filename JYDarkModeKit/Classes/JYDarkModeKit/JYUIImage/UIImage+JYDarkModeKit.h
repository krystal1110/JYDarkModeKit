//
//  UIImage+JYDarkModeKit.h
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/13.
//

#import <UIKit/UIKit.h>
#import "JYTraitCollection.h"
#import "JYDynamicImageProxy.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIImage (JYDarkModeKit) 

+ (UIImage *)jy_imageWithLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage;

 

@end

NS_ASSUME_NONNULL_END
