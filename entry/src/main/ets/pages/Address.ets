import { NavigationBar } from '../components/NavigationBar'
import { router } from '@kit.ArkUI'
import { AddressItem, AddressModel } from '../viewmodel/AddressModel'
import { Empty } from '../components/Empty'

class RouterParams {
  from: string = ''
}

@Entry
@Component
struct Address {
  @State from: string = ''
  @State addressList: AddressItem[] = [
    // { id: 1, name: '张三', phone: '1919199191', area: '北京市 东城区', detail: '天安门', is_default: 0 }
  ]

  aboutToAppear(): void {
    const params: RouterParams = router.getParams() as RouterParams
    this.from = params?.from
  }

  onPageShow(): void {
    this.getAddressList()
  }

  async getAddressList() {
    const res = await AddressModel.query()
    this.addressList = res || []
  }

  build() {
    Column() {
      NavigationBar({title: '收货地址'})
      if(!this.addressList.length) {
        Empty({desc: '暂无收货地址'})
      }
      List() {
        ForEach(this.addressList, (address: AddressItem) => {
          ListItem() {
            Row() {
              Column({space: 10}) {
                Row({space: 10}) {
                  Text(address.name)
                    .fontSize($r('app.float.font_size_large'))
                    .fontColor($r('app.color.text_color'))
                  Text(address.phone)
                    .fontSize($r('app.float.font_size'))
                    .fontColor($r('app.color.text_color_light'))
                }
                .width('100%')
                Text(address.area + ' ' + address.detail)
                  .fontSize($r('app.float.font_size'))
                  .fontColor($r('app.color.text_color_light'))
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
              Button('编辑')
                .margin({left: 16})
                .backgroundColor('transparent')
                .fontColor($r('app.color.text_color_light'))
                .fontSize($r('app.float.font_size'))
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/AddressDetail',
                    params: { id: address.id }
                  })
                })
            }
            .width('100%')
            .padding({top: 10, right: 16, bottom: 10, left: 16})
            .backgroundColor('#fff')
            .border({color: $r('app.color.border_color'), width: {bottom: 1}})
          }
          .onClick(() => {
            if(this.from === 'pages/OrderCreate') {
              AppStorage.set('selectAddress', address)
              router.back()
            }
          })
        }, (address: AddressItem) => `${address.id}`)
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
      Row() {
        Button('新增收货地址')
          .width('100%')
          .backgroundColor($r('app.color.bg_primary'))
          .onClick(() => {
            router.pushUrl({
              url: 'pages/AddressDetail'
            })
          })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#fff')
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}