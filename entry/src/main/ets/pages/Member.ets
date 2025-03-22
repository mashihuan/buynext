import { NavigationBar } from '../components/NavigationBar'
import { promptAction } from '@kit.ArkUI'

class PrivilegeItem {
  icon: ResourceStr = ''
  text: string = ''
}

class MemberItem {
  name: string = ''
  days: number = 0
  price: number = 0
}

type IMode = 'wechat' | 'ali'

class PayMode {
  name: string = ''
  icon: ResourceStr = ''
  mode: IMode | undefined = undefined
}

@Entry
@Component
struct Member {
  @State currentMemberIndex: number = 0
  @State payMode: string = ''
  privileges: PrivilegeItem[] = [
    { text: '特价', icon: $r('app.media.member_price') },
    { text: '两倍积分', icon: $r('app.media.member_integral') }
  ]
  members: MemberItem[] = [
    { name: '青铜会员', days: 30, price: 10 },
    { name: '黄金会员', days: 90, price: 25 },
    { name: '钻石会员', days: 180, price: 50 },
  ]
  payModes: PayMode[] = [
    { name: '微信支付', icon: $r('app.media.wechat'), mode: 'wechat' },
    { name: '支付宝支付', icon: $r('app.media.ali'), mode: 'ali' },
  ]

  build() {
    Column() {
      NavigationBar({title: '大会员'})
      Column() {
        Row() {
          ForEach(this.privileges, (item: PrivilegeItem) => {
            Column({space: 16}) {
              Image(item.icon)
                .width(44)
                .height(44)
              Text(item.text)
                .fontSize($r('app.float.font_size'))
                .fontColor($r('app.color.text_color'))
            }
            .width('50%')
          }, (item: PrivilegeItem) => item.text)
        }
        .width('100%')
        .margin({top: 27, bottom: 27})

        Column() {
          ForEach(this.members, (member: MemberItem, index: number) => {
            Row({space: 10}) {
              Text(member.name)
                .fontSize($r('app.float.font_size'))
                .fontColor($r('app.color.text_color'))
              Text(`${member.days}天`)
                .fontSize($r('app.float.font_size'))
                .fontColor($r('app.color.text_color'))
              Blank()
              Text(`￥${member.price}`)
                .fontSize($r('app.float.font_size'))
                .fontColor($r('app.color.price_color_new'))
            }
            .width('100%')
            .padding(16)
            .border({color: $r('app.color.border_color'), width: {bottom: 1}})
            .backgroundColor(this.currentMemberIndex === index ? $r('app.color.color_primary_light') : '')
            .onClick(() => {
              this.currentMemberIndex = index
            })
          }, (member: MemberItem) => member.name)
        }
        .width('100%')
        .border({color: $r('app.color.border_color'), width: {top: 1, right: 1, left: 1}})

        Column({space: 22}) {
          Text('支付方式')
            .fontSize($r('app.float.font_size_large'))
            .fontColor($r('app.color.text_color'))
          ForEach(this.payModes, (mode: PayMode) => {
            Row() {
              Image(mode.icon)
                .width(33)
                .height(33)
                .margin({right: 16})
              Text(mode.name)
                .fontSize($r('app.float.font_size'))
                .fontColor($r('app.color.text_color'))
              Blank()
              Radio({
                group: 'pay',
                value: mode.mode
              })
                .onChange((isChecked) => {
                  if(isChecked) {
                    this.payMode = mode.mode as string
                  }
                })
                .radioStyle({
                  checkedBackgroundColor: $r('app.color.color_primary')
                })
            }
            .width('100%')
          }, (mode: PayMode) => mode.name)
        }
        .width('100%')
        .margin({top: 33})
        .alignItems(HorizontalAlign.Start)

        Button('立即开通', {type: ButtonType.Normal})
          .width('100%')
          .margin({top: 80})
          .backgroundColor($r('app.color.bg_primary'))
          .borderRadius(5)
          .onClick(() => {
            promptAction.showToast({message: '点击了立即开通'})
          })

      }
      .width('100%')
      .padding({right: 16, left: 16})
    }
    .height('100%')
    .width('100%')
  }
}