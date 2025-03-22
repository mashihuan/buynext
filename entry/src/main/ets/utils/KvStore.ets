import { common } from "@kit.AbilityKit";
import { distributedKVStore } from "@kit.ArkData";
import { BusinessError } from "@kit.BasicServicesKit";
import { Constants } from "../common/Constants";

class KvStore {
   // 管理数据库对象
   private kvManager: distributedKVStore.KVManager | undefined = undefined;
   // 键值数据库
   private kvStore: distributedKVStore.SingleKVStore | undefined = undefined;

   async createKVManager(context: common.Context, bundleName: string) {
      const kvManagerConfig: distributedKVStore.KVManagerConfig = {
         context: context,
         bundleName: bundleName
      };
      try {
         // 创建KVManager实例
         this.kvManager = distributedKVStore.createKVManager(kvManagerConfig);
         await this.getKVStore(Constants.KV_STORE_NAME)
         console.info('Succeeded in creating KVManager.');
         // 继续创建获取数据库
      } catch (e) {
         let error = e as BusinessError;
         console.error(`Failed to create KVManager. Code:${error.code},message:${error.message}`);
      }
   }

   async getKVStore(storeId: string) {
      const options: distributedKVStore.Options = {
         createIfMissing: true,
         encrypt: false,
         backup: false,
         autoSync: false,
         // kvStoreType不填时，默认创建多设备协同数据库
         kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
         // 多设备协同数据库：kvStoreType: distributedKVStore.KVStoreType.DEVICE_COLLABORATION,
         securityLevel: distributedKVStore.SecurityLevel.S1
      };
      if(this.kvManager) {
         try {
            this.kvStore = await this.kvManager.getKVStore<distributedKVStore.SingleKVStore>(storeId, options)
            console.info('Succeeded in getting KVStore.');
         }catch (err) {
            console.error(`Failed to get KVStore: Code:${err.code},message:${err.message}`);
         }
      }
   }

   async put(key: string, value: string) {
      if(this.kvStore) {
         try {
            await this.kvStore.put(key, value);
         } catch (e) {
            let error = e as BusinessError;
            console.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
         }
      }
   }

   async get(key: string) {
      let res: string | number | boolean | Uint8Array = ''
      if(this.kvStore) {
         try {
            res = await this.kvStore.get(key)
         } catch (e) {
            let error = e as BusinessError;
            console.error(`Failed to get data. Code:${error.code},message:${error.message}`);
         }
      }

      return res
   }

   async delete(key: string) {
      if(this.kvStore) {
         try {
            await this.kvStore.delete(key);
         } catch (e) {
            let error = e as BusinessError;
            console.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
         }
      }
   }
}

const kvStore = new KvStore()

export {
   kvStore
}