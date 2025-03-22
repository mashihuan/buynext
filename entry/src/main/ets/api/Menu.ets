import { http } from '@kit.NetworkKit'
import { request } from '../utils/HttpUtil'
import { IHttpResponseResult } from '../utils/Types'

export function requestMenuList<T, K>(data?: K): Promise<IHttpResponseResult<T>> {
  return request<T>(`/menu`, {
    method: http.RequestMethod.GET,
    extraData: data || ''
  })
}

export function requestMenuById<T, K>(data?: K): Promise<IHttpResponseResult<T>> {
  return request<T>(`/menu/detail`, {
    method: http.RequestMethod.GET,
    extraData: data || ''
  })
}