import { http } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction, router } from '@kit.ArkUI'
import { BASE_URL } from '../common/Config'
import { IHttpResponseResult } from './Types';
import { deleteToken, getToken, TOKEN_KEY } from './Auth';

export function request<T>(url: string, options: http.HttpRequestOptions) {

  return new Promise(async (resolve: (result: IHttpResponseResult<T>) => void, reject: (err: BusinessError) => void) => {
    let httpRequest = http.createHttp();
    let paramsStr = '?'

    // httpRequest.on('headersReceive', (header: Object) => {
    //   console.info('header: ' + JSON.stringify(header));
    // });

    options.connectTimeout = options.connectTimeout || 60000
    options.header = options.header ? options.header : {} as Record<string, string | number | boolean | Uint8Array>
    options.header[TOKEN_KEY] = await getToken()
    options.header['content-type'] = 'application/json'

    if(options.method === http.RequestMethod.GET && options.extraData) {
      let params = options.extraData as Record<string, string | number | boolean | Uint8Array>
      Object.keys(params).forEach(key => {
        paramsStr += `${key}=${params[key]}&`
      })
      // console.log(paramsStr)
    }

    httpRequest.request(BASE_URL + url + paramsStr, options, async (err: BusinessError, data: http.HttpResponse) => {
      if(!err) {

        if(data.result) {
          let result = JSON.parse(data.result as string) as IHttpResponseResult<T>
          // console.log('请求成功:' + JSON.stringify(result));
          if(data.responseCode === 401) {
            // 清除token
            // await deleteToken()
            // router.replaceUrl({
            //   url: 'pages/Login'
            // })
          }
          if(result.return_code !== 20000) {
            promptAction.showToast({message: result.message})
          }
          resolve(result)
        }else {
          promptAction.showToast({message: `${data.responseCode}`})
        }
        httpRequest.off('headersReceive');
        httpRequest.destroy();
      }else {
        console.error('请求失败:' + JSON.stringify(err));
        reject(err)
        httpRequest.off('headersReceive');
        httpRequest.destroy();
      }
    })
  })
}