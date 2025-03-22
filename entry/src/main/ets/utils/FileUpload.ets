import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { BusinessError, request } from "@kit.BasicServicesKit";
import { common } from "@kit.AbilityKit";
import fs from '@ohos.file.fs';
import { getToken } from "./Auth";

// 获取应用文件路径
let context = getContext(this) as common.UIAbilityContext;
let cacheDir = context.cacheDir;

export async function fileUpload(uris: string[]) {
  // 将文件拷贝到缓存
  let files: Array<request.File> = [
  //uri前缀internal://cache 对应cacheDir目录
  //   { filename: '', name: 'file', uri: 'internal://cache/test.txt', type: '' }
  ]
  console.log('uris', JSON.stringify(uris))
  uris.forEach((uri) => {
    let file = fs.openSync(uri, fs.OpenMode.READ_ONLY);
    const dotLastIndex = uri.lastIndexOf('.')
    const ext = uri.slice(dotLastIndex + 1)
    const pathLastIndex = uri.lastIndexOf('/')
    const filename = uri.slice(pathLastIndex + 1)
    fs.copyFileSync(file.fd, uri)
    // console.log('ext', ext, 'filename', filename)
    files.push({ filename: filename, name: 'file', uri: `internal://cache/${filename}`, type: ext })
  })

  // 上传任务配置项
  let data: Array<request.RequestData> = [{ name: 'name', value: 'value' }];
  let uploadConfig: request.UploadConfig = {
    url: 'https://xxx',
    header: {
      accessToken: getToken()
    },
    method: 'POST',
    files: files,
    data: data
  }

  // 将本地应用文件上传至网络服务器
  try {
    request.uploadFile(context, uploadConfig)
      .then((uploadTask: request.UploadTask) => {
        uploadTask.on('complete', (taskStates: Array<request.TaskState>) => {
          for (let i = 0; i < taskStates.length; i++) {
            console.info(`upload complete taskState: ${JSON.stringify(taskStates[i])}`);
          }
        });
      })
      .catch((err: BusinessError) => {
        console.error(`Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);
      })
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(`Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);
  }

}

export async function photoSelect(number?: number): Promise<string[]> {
  let photoUris:string[] = []
  try {
    let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    PhotoSelectOptions.maxSelectNumber = number || 1;
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    const PhotoSelectResult = await photoPicker.select(PhotoSelectOptions)
    photoUris = PhotoSelectResult.photoUris
    console.info('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(`PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
  }
  return photoUris
}