import { rdbStore } from "../utils/RdbStore"
import { IRdbColumn, ColumnType } from "../utils/Types"
import { relationalStore } from "@kit.ArkData"
import { GoodsItem } from "./GoodsModel"

const TABLE_NAME = 'ORDER_GOODS'

const SQL_CREATE_TABLE = `CREATE TABLE IF NOT EXISTS ${TABLE_NAME}
(id INTEGER PRIMARY KEY AUTOINCREMENT,
goods_id INTEGER NOT NULL,
order_id INTEGER NOT NULL,
num INTEGER NOT NULL,
price INTEGER NOT NULL)`

const COLUMNS: IRdbColumn[] = [
  { name: 'id', columnName: 'id', type: ColumnType.LONG },
  // { name: 'user_id', columnName: 'user_id', type: ColumnType.LONG },
  { name: 'goods_id', columnName: 'goods_id', type: ColumnType.LONG },
  { name: 'order_id', columnName: 'order_id', type: ColumnType.LONG },
  { name: 'num', columnName: 'num', type: ColumnType.LONG },
  { name: 'price', columnName: 'price', type: ColumnType.LONG },
]

export class OrderGoodsItem {
  id: number = 0
  user_id?: number = 0
  goods_id: number = 0
  order_id: number = 0
  num: number = 0
  price: number = 0
  goods: GoodsItem | undefined = undefined
}

export interface IOrderGoodsAdd {
  id?: number
  goods_id: number
  order_id: number
  num: number
  price: number
}

export class OrderGoodsModel {
  static tableName: string = TABLE_NAME
  static sqlCreateTable: string = SQL_CREATE_TABLE

  static async insert(data: IOrderGoodsAdd) {
    return await rdbStore.insert<IOrderGoodsAdd>(TABLE_NAME, data, COLUMNS)
  }

  static async batchInsert(data: IOrderGoodsAdd[]) {
    return await rdbStore.batchInsert<IOrderGoodsAdd[]>(TABLE_NAME, data, COLUMNS)
  }

  static async update(data: Partial<IOrderGoodsAdd>) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo('id', data.id)
    return await rdbStore.update<Partial<IOrderGoodsAdd>>(predicates, data, COLUMNS)
  }

  static async delete(id: number) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo('id', id)
    return await rdbStore.delete(predicates)
  }

  static async deleteList(ids: number[]) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.in("id", [...ids])
    return await rdbStore.delete(predicates)
  }

  static async query() {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    return await rdbStore.query<OrderGoodsItem>(predicates, COLUMNS)
  }

  static async get(id: number) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo('id', id)
    return await rdbStore.query<OrderGoodsItem>(predicates, COLUMNS)
  }

  static async getByOrderId(order_id: number) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo('order_id', order_id)
    return await rdbStore.query<OrderGoodsItem>(predicates, COLUMNS)
  }
}
