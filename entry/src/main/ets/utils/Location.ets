import { geoLocationManager } from '@kit.LocationKit';

export async function getCurrentLocation() {
  let result: geoLocationManager.Location | undefined = undefined
  let request: geoLocationManager.SingleLocationRequest = {
    'locatingPriority': geoLocationManager.LocatingPriority.PRIORITY_LOCATING_SPEED,
    'locatingTimeoutMs': 10000
  }
  try {
    result = await geoLocationManager.getCurrentLocation(request)
  } catch (err) {
    console.error(`Failed to getCurrentLocation. Code is ${err.code}, message is ${err.message}`);
  }
  return result
}