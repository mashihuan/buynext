import { rdbStore } from "../utils/RdbStore"
import { IRdbColumn, ColumnType } from "../utils/Types"
import { relationalStore } from "@kit.ArkData"

const TABLE_NAME = 'ADDRESS'

const SQL_CREATE_TABLE = `CREATE TABLE IF NOT EXISTS ${TABLE_NAME}
(id INTEGER PRIMARY KEY AUTOINCREMENT,
name STRING NOT NULL,
phone STRING NOT NULL,
area STRING NOT NULL,
detail STRING NOT NULL,
is_default LONG NOT NULL)`

const COLUMNS: IRdbColumn[] = [
  { name: 'id', columnName: 'id', type: ColumnType.LONG },
  // { name: 'user_id', columnName: 'user_id', type: ColumnType.LONG },
  { name: 'name', columnName: 'name', type: ColumnType.STRING },
  { name: 'phone', columnName: 'phone', type: ColumnType.STRING },
  { name: 'area', columnName: 'area', type: ColumnType.STRING },
  { name: 'detail', columnName: 'detail', type: ColumnType.STRING },
  { name: 'is_default', columnName: 'is_default', type: ColumnType.LONG },
]

@Observed
export class AddressItem {
  id: number = 0
  user_id?: number = 0
  name: string = ''
  phone: string = ''
  area: string = ''
  detail: string = ''
  is_default: number = 0
}

interface IAddressAdd {
  id?: number
  name: string
  phone: string
  area: string
  detail: string
  is_default: number
}

export class AddressModel {
  static tableName: string = TABLE_NAME
  static sqlCreateTable: string = SQL_CREATE_TABLE

  static async insert(data: IAddressAdd) {
    return await rdbStore.insert<IAddressAdd>(TABLE_NAME, data, COLUMNS)
  }

  static async update(data: Partial<IAddressAdd>) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo('id', data.id)
    return await rdbStore.update<Partial<IAddressAdd>>(predicates, data, COLUMNS)
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
    return await rdbStore.query<AddressItem>(predicates, COLUMNS)
  }

  static async get(id: number) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo('id', id)
    return await rdbStore.query<AddressItem>(predicates, COLUMNS)
  }

  static async getByIsDefault(is_default: number) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo('is_default', is_default)
    return await rdbStore.query<AddressItem>(predicates, COLUMNS)
  }
}
