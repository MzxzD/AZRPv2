#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Emitter+Blocks.h"
#import "Emitter+Selectors.h"
#import "Emitter.h"
#import "NSInvocation+BlockArguments.h"

FOUNDATION_EXPORT double EmitterVersionNumber;
FOUNDATION_EXPORT const unsigned char EmitterVersionString[];

