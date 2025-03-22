import { rdbStore } from "../utils/RdbStore"
import { IRdbColumn, ColumnType } from "../utils/Types"
import { relationalStore } from "@kit.ArkData"
import { OrderGoodsItem } from "./OrderGoodsModel"

export enum OrderStatus {
  ALL,
  NO_PAY,
  NO_DELIVERY,
  NO_COMMENT
}

const TABLE_NAME = 'ORDER_LIST'

const SQL_CREATE_TABLE = `CREATE TABLE IF NOT EXISTS ${TABLE_NAME}
(id INTEGER PRIMARY KEY AUTOINCREMENT,
address_id INTEGER NOT NULL,
status INTEGER NOT NULL)`

const COLUMNS: IRdbColumn[] = [
  { name: 'id', columnName: 'id', type: ColumnType.LONG },
  // { name: 'user_id', columnName: 'user_id', type: ColumnType.LONG },
  { name: 'address_id', columnName: 'address_id', type: ColumnType.LONG },
  { name: 'status', columnName: 'status', type: ColumnType.LONG },
]


export class OrderItem {
  id: number = 0
  user_id?: number = 0
  address_id: number = 0
  status: OrderStatus = OrderStatus.ALL
  goodsList: OrderGoodsItem[] = []
  total_num: number = 0
  total_price: number = 0
}

interface IOrderAdd {
  id?: number
  address_id: number
  status: OrderStatus
}

export class OrderModel {
  static tableName: string = TABLE_NAME
  static sqlCreateTable: string = SQL_CREATE_TABLE

  static async insert(data: IOrderAdd) {
    return await rdbStore.insert<IOrderAdd>(TABLE_NAME, data, COLUMNS)
  }

  static async update(data: Partial<IOrderAdd>) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo('id', data.id)
    return await rdbStore.update<Partial<IOrderAdd>>(predicates, data, COLUMNS)
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
    return await rdbStore.query<OrderItem>(predicates, COLUMNS)
  }

  static async get(id: number) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo('id', id)
    return await rdbStore.query<OrderItem>(predicates, COLUMNS)
  }

  static async getByStatus(status: OrderStatus) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo('status', status)
    return await rdbStore.query<OrderItem>(predicates, COLUMNS)
  }
}
