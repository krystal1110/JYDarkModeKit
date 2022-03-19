//
//  JYDynamicColor.h
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JYTraitCollection.h"


NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(DynamicColor)

@interface JYDynamicColor : UIColor


@property (nonatomic, readonly) UIColor * lightColor;

@property (nonatomic, readonly) UIColor * darkColor;

+ (UIColor *)colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;

+ (UIColor *)colorWithDynamicProvider:(UIColor * (^)(JYTraitCollection *traitCollection))dynamicProvider;

@end

NS_ASSUME_NONNULL_END
