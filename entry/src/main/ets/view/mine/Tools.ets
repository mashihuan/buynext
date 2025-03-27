import { router } from "@kit.ArkUI"

class ToolType {
  icon: ResourceStr = ''
  text: string = ''
  path: string = ''
  type?: string = ''
}

@Component
export struct MineTools {
  toolTypes: ToolType[] = [
    { text: '会员卡', icon: $r('app.media.tool_member'), path: 'pages/Member' },
    { text: '收货地址', icon: $r('app.media.tool_address'), path: 'pages/Address' },
    { text: '邀请有礼', icon: $r('app.media.tool_invite'), path: 'pages/Invite' },
    { text: '联系客服', icon: $r('app.media.tool_service'), path: 'pages/Service' },
    { text: '意见反馈', icon: $r('app.media.tool_feedback'), path: 'pages/Feedback' },
    { text: '设置', icon: $r('app.media.tool_settings'), path: 'pages/Settings' },
    // { text: '地图', icon: $r('app.media.icon_map'), path: 'pages/Map' },
    // { text: '图表', icon: $r('app.media.icon_chart'), path: 'pages/Chart' },
  ]

  build() {
    Column() {
      Row() {
        Text('工具与服务')
          .fontSize($r('app.float.font_size_large'))
          .fontColor($r('app.color.text_color'))
      }
      .width('100%')

      Flex({alignItems: ItemAlign.Center, wrap: FlexWrap.Wrap}) {
        ForEach(this.toolTypes, (toolTypes: ToolType) =>{
          Column({space: 10}) {
            Image(toolTypes.icon)
              .width(24)
              .height(24)
              .objectFit(ImageFit.Contain)
            Text(toolTypes.text)
              .fontSize($r('app.float.font_size'))
              .fontColor($r('app.color.text_color_light'))
          }
          .width('25%')
          .height(70)
          .justifyContent(FlexAlign.End)
          .onClick(() => {
            router.pushUrl({
              url: toolTypes.path
            })
          })
        }, (orderType: ToolType) => orderType.text)
      }
      .width('100%')
    }
    .width('100%')
    .padding(10)
    .margin({top: 10})
    .borderRadius(5)
    .backgroundColor('#fff')
  }
}