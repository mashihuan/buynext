import { http } from '@kit.NetworkKit'
import { request } from '../utils/HttpUtil'
import { IHttpResponseResult } from '../utils/Types'

export function requestGoodsList<T, K>(data?: K): Promise<IHttpResponseResult<T>> {
  return request<T>(`/goods`, {
    method: http.RequestMethod.GET,
    extraData: data || ''
  })
}

export function requestGoodsById<T, K>(data?: K): Promise<IHttpResponseResult<T>> {
  return request<T>(`/goods/detail`, {
    method: http.RequestMethod.GET,
    extraData: data || ''
  })
}