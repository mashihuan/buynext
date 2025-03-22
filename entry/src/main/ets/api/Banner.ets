import { http } from '@kit.NetworkKit'
import { request } from '../utils/HttpUtil'
import { IHttpResponseResult } from '../utils/Types'

export function requestBannerList<T, K>(data?: K): Promise<IHttpResponseResult<T>> {
  return request<T>('/banner', {
    method: http.RequestMethod.GET,
    extraData: data || ''
  })
}