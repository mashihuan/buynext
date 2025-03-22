export interface IHttpResponseResult<T> {
  return_code: number
  message: string
  data: Record<string, T>
}

export interface IGoodsListByCategoryParams {
  category_id: number,
}

export enum ColumnType {
  LONG,
  DOUBLE,
  STRING,
  BLOB
}

export type ColumnValueType = string | number | boolean | Uint8Array

export interface IRdbColumn {
  name: string
  columnName: string
  type: ColumnType
}

export type ICallback = () => void