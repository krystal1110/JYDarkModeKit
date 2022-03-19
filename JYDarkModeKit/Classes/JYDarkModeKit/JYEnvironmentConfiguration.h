//
//  JYEnvironmentConfiguration.h
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYEnvironmentConfiguration : NSObject


@property (nonatomic) BOOL useImageAsset API_AVAILABLE(ios(13.0));
@property (nullable, nonatomic) void (^themeChangeHandler)(void);
@property (nullable, nonatomic) void (^windowThemeChangeHandler)(UIWindow *) API_AVAILABLE(ios(13.0)); // Defaults to nil

+ (instancetype)initWithThemeChangeHandler:(void(^)(void))themeChangeHandler;

@end

NS_ASSUME_NONNULL_END
