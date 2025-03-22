import { relationalStore } from "@kit.ArkData";
import { common } from "@kit.AbilityKit";
import { ColumnType, ColumnValueType, IRdbColumn } from "./Types";
import { Constants } from "../common/Constants";

class RdbStore {
  private store: relationalStore.RdbStore | undefined = undefined;

  STORE_CONFIG: relationalStore.StoreConfig= {
    name: Constants.RDB_STORE_NAME, // 数据库文件名
    securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
  };

  async getRdbStore(context: common.Context) {
    try {
      this.store = await relationalStore.getRdbStore(context, this.STORE_CONFIG)
      console.info('Succeeded in getting RdbStore.');
    }catch (err) {
      console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
    }
  }

  async getTable(sql: string) {
    if(this.store) {
      try {
        await this.store.executeSql(sql)
        // console.info(`Succeeded in executeSql sql. sql:${sql}`);
      } catch (err) {
        console.error(`Failed to executeSql ${sql}. Code:${err.code}, message:${err.message}`)
      }
    }
  }

  async insert<T>(table: string, data: T, columns: IRdbColumn[]) {
    let rowId: number = 0
    if(this.store) {
      try {
        const values = this.buildValuesBucket<T>(data, columns)
        rowId = await this.store.insert(table, values)
        console.info(`Succeeded in inserting data. rowId:${rowId}`);
      }catch (err) {
        console.error(`Failed to insert data. Code:${err.code}, message:${err.message}`);
      }
    }
    return rowId
  }

  async batchInsert<T>(table: string, data: T, columns: IRdbColumn[]) {
    let rows: number = 0
    if(this.store) {
      try {
        let values: relationalStore.ValuesBucket[] = [] as relationalStore.ValuesBucket[]
        (data as Record<string,ColumnValueType>[]).forEach((item: Record<string,ColumnValueType>) => {
          values.push(this.buildValuesBucket(item, columns))
        })
        rows = await this.store.batchInsert(table, values)
      } catch (err) {
        console.error(`Failed to batchInsert data. Code:${err.code}, message:${err.message}`)
      }
    }
    return rows
  }

  async update<T>(predicates: relationalStore.RdbPredicates, data: T, columns: IRdbColumn[]) {
    let rowId: number = 0
    if(this.store) {
      try {
        const values = this.buildValuesBucket(data, columns)
        rowId = await this.store.update(values, predicates)
      }catch (err) {
        console.error(`Failed to update data. Code:${err.code}, message:${err.message}`);
      }
    }
    return rowId
  }

  async delete(predicates: relationalStore.RdbPredicates) {
    let rowId: number = 0
    if(this.store) {
      try {
        rowId = await this.store.delete(predicates)
      }catch (err) {
        console.error(`Failed to delete data. Code:${err.code}, message:${err.message}`);
      }
    }
    return rowId
  }

  async query<T>(predicates: relationalStore.RdbPredicates, columns: IRdbColumn[]) {
    let res: T[] = []
    if(this.store) {
      try {
        const result = await this.store.query(predicates, columns.map(column => column.columnName))
        res = this.parseResultSet<T>(result, columns)
      } catch (err) {
        console.error('testTag', `Failed to query data. Code:${err.code}, message:${err.message}`)
      }
    }
    return res
  }

  parseResultSet<T>(result: relationalStore.ResultSet, columns: IRdbColumn[]) {
    const arr:T[] = []
    if (result.rowCount <= 0) {
      return arr
    }
    while (!result.isAtLastRow) {
      result.goToNextRow()
      const obj:Record<string, ColumnValueType> = {}
      columns.forEach(column => {
        let val: ColumnValueType = ''
        switch (column.type) {
          case ColumnType.LONG:
            val = result.getLong(result.getColumnIndex(column.columnName))
            break;
          case ColumnType.DOUBLE:
            val = result.getDouble(result.getColumnIndex(column.columnName))
            break;
          case ColumnType.STRING:
            val = result.getString(result.getColumnIndex(column.columnName))
            break;
          case ColumnType.BLOB:
            val = result.getBlob(result.getColumnIndex(column.columnName))
            break;
          default:
            break;
        }
        obj[column.name] = val
      })
      arr.push(obj as  T)
    }
    return arr
  }

  buildValuesBucket<T>(data: T, columns: IRdbColumn[]): relationalStore.ValuesBucket {
    const values: relationalStore.ValuesBucket = {}
    columns.forEach(column => {
      const val: ColumnValueType = (data as Record<string, ColumnValueType>)[column.name]
      if (typeof val !== 'undefined') {
        values[column.columnName] = val
      }
    })
    return values
  }
}

const rdbStore = new RdbStore()

export {
  rdbStore
}