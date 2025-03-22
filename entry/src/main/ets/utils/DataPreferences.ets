import { common } from "@kit.AbilityKit";
import { preferences } from "@kit.ArkData";
import { Constants } from "../common/Constants";

class DataPreferences {
  private dataPreferences: preferences.Preferences | null = null

  getPreferencesSync(context: common.Context) {
    let options: preferences.Options = { name: Constants.PREFERENCES_NAME };
    this.dataPreferences = preferences.getPreferencesSync(context, options);
  }

  async put(key: string, value: preferences.ValueType) {
    if(this.dataPreferences) {
      try {
        await this.dataPreferences.put(key, value);
        await this.dataPreferences.flush()
      }catch (err) {
        console.error(`Failed to flush. Code:${err.code}, message:${err.message}`);
      }
    }
  }

  async get(key: string, defaultValue?:preferences.ValueType) {
    let res:preferences.ValueType = ''
    if(this.dataPreferences) {
      try {
        res = await this.dataPreferences.get(key, defaultValue);
      }catch (err) {
        console.error('testTag', `Failed to get value. Code:${err.code}, message:${err.message}`)
      }
    }
    return res
  }

  async delete(key: string) {
    if(this.dataPreferences) {
      try {
        await this.dataPreferences.delete(key);
      }catch (err) {
        console.error('testTag', `Failed to delete. Code:${err.code}, message:${err.message}`)
      }
    }
  }
}

const dataPreferences = new DataPreferences()

export {
  dataPreferences
}