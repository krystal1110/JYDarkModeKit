//
//  UIScreen+JYTraitEnviroment.h
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/11.
//

#import <UIKit/UIKit.h>
#import "JYTraitCollection.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (JYTraitEnviroment)<JYTraitEnvironment>

+ (void)swizzleUIScreenTraitCollectionDidChange API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
