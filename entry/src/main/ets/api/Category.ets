import { http } from '@kit.NetworkKit'
import { request } from '../utils/HttpUtil'
import { IHttpResponseResult } from '../utils/Types'

export function requestHomeCategory<T, K>(data?: K): Promise<IHttpResponseResult<T>> {
  return request<T>('/category/home', {
    method: http.RequestMethod.GET,
    extraData: data || ''
  })
}

export function requestCategoryList<T, K>(data?: K): Promise<IHttpResponseResult<T>> {
  return request<T>('/category/all', {
    method: http.RequestMethod.GET,
    extraData: data || ''
  })
}