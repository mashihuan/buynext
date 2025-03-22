import { rdbStore } from "../utils/RdbStore"
import { IRdbColumn, ColumnType } from "../utils/Types"
import { GoodsItem } from "./GoodsModel"
import { relationalStore } from "@kit.ArkData"

const TABLE_NAME = 'CART'

const SQL_CREATE_TABLE = `CREATE TABLE IF NOT EXISTS ${TABLE_NAME}
(id INTEGER PRIMARY KEY AUTOINCREMENT,
goods_id INTEGER NOT NULL,
num INTEGER NOT NULL)`

const COLUMNS: IRdbColumn[] = [
  { name: 'id', columnName: 'id', type: ColumnType.LONG },
  // { name: 'user_id', columnName: 'user_id', type: ColumnType.LONG },
  { name: 'goods_id', columnName: 'goods_id', type: ColumnType.LONG },
  { name: 'num', columnName: 'num', type: ColumnType.LONG },
]

@Observed
export class CartItem {
  id: number
  goods_id: number
  num: number
  goods: GoodsItem
  user_id?: number

  constructor(id: number, goods_id: number, num: number, goods: GoodsItem, user_id?: number) {
    this.id = id
    this.goods_id = goods_id
    this.num = num
    this.goods = goods
    this.user_id = user_id
  }
}

interface ICartAdd {
  goods_id?: number
  num: number
  id?: number
}

export class CartModel {
  static tableName: string = TABLE_NAME
  static sqlCreateTable: string = SQL_CREATE_TABLE

  static async insert(data: ICartAdd) {
    return await rdbStore.insert<ICartAdd>(TABLE_NAME, data, COLUMNS)
  }

  static async update(data: ICartAdd) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo('id', data.id)
    return await rdbStore.update<ICartAdd>(predicates, data, COLUMNS)
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
    return await rdbStore.query<CartItem>(predicates, COLUMNS)
  }

  static async queryByGoodsId(goods_id: number) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo('goods_id', goods_id)
    return await rdbStore.query<CartItem>(predicates, COLUMNS)
  }
}
