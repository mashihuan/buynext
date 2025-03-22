import { relationalStore } from "@kit.ArkData"
import { ColumnType, IRdbColumn } from "../utils/Types"
import { BannerItem } from "./BannerModel"
import { rdbStore } from "../utils/RdbStore"

const TABLE_NAME = 'GOODS'

const SQL_CREATE_TABLE = `CREATE TABLE IF NOT EXISTS ${TABLE_NAME}
(id INTEGER PRIMARY KEY AUTOINCREMENT,
name STRING NOT NULL,
desc STRING NOT NULL,
icon STRING NOT NULL,
new_price DOUBLE NOT NULL,
old_price DOUBLE NOT NULL,
category_id INTEGER NOT NULL)`

const COLUMNS: IRdbColumn[] = [
  { name: 'id', columnName: 'id', type: ColumnType.LONG },
  { name: 'name', columnName: 'name', type: ColumnType.STRING },
  { name: 'desc', columnName: 'desc', type: ColumnType.STRING },
  { name: 'icon', columnName: 'icon', type: ColumnType.STRING },
  { name: 'new_price', columnName: 'new_price', type: ColumnType.DOUBLE },
  { name: 'old_price', columnName: 'old_price', type: ColumnType.DOUBLE },
  { name: 'category_id', columnName: 'category_id', type: ColumnType.LONG },
]

export class GoodsItem {
  id: number = 0
  name: string = ''
  desc: string = ''
  icon: ResourceStr = ''
  new_price: number = 0
  old_price: number = 0
  category_id: number = 0
  banner?: BannerItem[]
}

export class GoodsModel {
  static tableName: string = TABLE_NAME
  static sqlCreateTable: string = SQL_CREATE_TABLE

  static async batchInsert(data: GoodsItem[]) {
    return await rdbStore.batchInsert<GoodsItem[]>(TABLE_NAME, data, COLUMNS)
  }

  static async query() {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    return await rdbStore.query<GoodsItem>(predicates, COLUMNS)
  }

  static async get(id: number) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo('id', id)
    return await rdbStore.query<GoodsItem>(predicates, COLUMNS)
  }
}