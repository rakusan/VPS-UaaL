// [!] important set UnityFramework in Target Membership for this file
// [!]           and set Public header visibility

#import <Foundation/Foundation.h>

// NativeCallsProtocol defines protocol with methods you want to be called from managed
@protocol NativeCallsProtocol
@required
- (void) updateInfoText:(NSString*)infoText;
- (void) updateLocation:(double)latitude :(double)longitude;
- (void) updateSnackBarText:(NSString*)snackBarText;
- (void) updateDebugText:(NSString*)debugText;
- (void) clearAllButtonSetActive:(bool)active;
- (void) setAnchorButtonSetActive:(bool)active;
- (void) debugTextSetActive:(bool)active;

// other methods
@end

__attribute__ ((visibility("default")))
@interface FrameworkLibAPI : NSObject
// call it any time after UnityFrameworkLoad to set object implementing NativeCallsProtocol methods
+(void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) aApi;

@end


