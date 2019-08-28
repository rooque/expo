import { UnavailabilityError } from '@unimodules/core';
import { once } from 'lodash';
import ExpoErrorRecovery from './ExpoErrorRecovery';
const globalHandlerSwapper = once(() => {
    // ErrorUtlis came from react-native
    // https://github.com/facebook/react-native/blob/1151c096dab17e5d9a6ac05b61aacecd4305f3db/Libraries/vendor/core/ErrorUtils.js#L25
    const globalHandler = ErrorUtils.getGlobalHandler();
    ErrorUtils.setGlobalHandler(async (error, isFatal) => {
        await ExpoErrorRecovery.saveRecoveryProps();
        globalHandler(error, isFatal);
    });
});
export const errors = _parseNativeErrors();
export function setRecoveryProps(props) {
    if (!ExpoErrorRecovery.setRecoveryProps) {
        throw new UnavailabilityError('ErrorRecovery', 'setRecoveryProps');
    }
    ExpoErrorRecovery.setRecoveryProps(JSON.stringify(props));
    globalHandlerSwapper();
}
function _parseNativeErrors() {
    if (ExpoErrorRecovery.errors) {
        return JSON.parse(ExpoErrorRecovery.errors);
    }
    return undefined;
}
//# sourceMappingURL=ErrorRecovery.js.map