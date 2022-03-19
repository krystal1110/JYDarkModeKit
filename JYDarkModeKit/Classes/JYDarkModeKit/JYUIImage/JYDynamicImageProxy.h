//
//  JYDynamicImage.h
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface JYDynamicImageProxy : NSProxy

@property (nonatomic, readonly) UIImage *resolvedImage;

- (instancetype)initWithLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage;

@end

NS_ASSUME_NONNULL_END
