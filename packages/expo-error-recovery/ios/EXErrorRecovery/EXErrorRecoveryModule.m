// Copyright 2018-present 650 Industries. All rights reserved.

#import <EXErrorRecovery/EXErrorRecoveryModule.h>

NSString * const userDefaultsKey = @"expo.errorRecovery";

@interface EXErrorRecoveryModule ()

@property (nonatomic, strong) NSString *recoveryPropsToSave;

@end

@implementation EXErrorRecoveryModule

UM_EXPORT_MODULE(ExpoErrorRecovery);

UM_EXPORT_METHOD_AS(setRecoveryProps,
                    setRecoveryProps:(NSString *)props
                    resovler:(UMPromiseResolveBlock)resolve
                    rejecter:(UMPromiseRejectBlock)reject)
{
  _recoveryPropsToSave = props;
  resolve(nil);
}

UM_EXPORT_METHOD_AS(saveRecoveryProps,
                    saveRecoveryProps:(UMPromiseResolveBlock)resolve
                    rejecter:(UMPromiseRejectBlock)reject)
{
  if (_recoveryPropsToSave != nil) {
    if (![self pushProps:_recoveryPropsToSave]) {
      return reject(@"E_ERROR_RECOVERY_SAVE_FAILED", @"Couldn't save props.", nil);
    }
    _recoveryPropsToSave = nil;
  }
  resolve(nil);
}

- (NSDictionary *)constantsToExport
{
  return @{
           @"errors": [self popProps]
           };
}

- (BOOL)pushProps:(NSString *)props {
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  [preferences setObject:props forKey:userDefaultsKey];
  return [preferences synchronize];
}

- (NSString *)popProps
{
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  NSString *props = [preferences objectForKey:userDefaultsKey];
  if (props != nil) {
    [preferences removeObjectForKey:userDefaultsKey];
    [preferences synchronize];
  }
  return props;
}

@end
