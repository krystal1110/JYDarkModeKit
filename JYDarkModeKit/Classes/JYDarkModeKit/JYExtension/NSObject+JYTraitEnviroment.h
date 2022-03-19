//
//  NSObject+JYTraitEnviroment.h
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/11.
//

#import <Foundation/Foundation.h>
#import "JYTraitCollection.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JYTraitEnviroment)

+ (void)swizzleTraitCollectionDidChangeToJYTraitCollectionDidChange;

+ (void)swizzleTraitCollectionDidChangeToJYTraitCollectionDidChangeWithBlock:(void (^)(id<UITraitEnvironment>, UITraitCollection *))block API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
