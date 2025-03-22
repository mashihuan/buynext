import { promptAction, router } from "@kit.ArkUI"
import { reqPermissionsFromUser } from "../../utils/PermissionsFromUser"
import { common, Permissions } from "@kit.AbilityKit"
import { getCurrentLocation } from "../../utils/Location"

class Tip {
  icon: ResourceStr = ''
  text: ResourceStr = ''
}

@Component
export struct HomeHeader {
  @State location: string = '北京市'

  tips: Tip[] = [
    { icon: $r('app.media.icon_deliver'), text: '最快29分钟到达' },
    { icon: $r('app.media.icon_fruit'), text: '保障新鲜到家' },
    { icon: $r('app.media.icon_refund'), text: '无理由退换货' },
  ]

  build() {
    Column() {
      Row() {
        Column() {
          Image($r('app.media.icon_location'))
            .width(16)
            .height(16)
          Text(this.location)
            .fontSize($r('app.float.font_size_small'))
            .fontColor('#fff')
            .lineHeight(16)
        }
        .onClick(async () => {
          promptAction.showToast({message: '点击了定位'})
          const permissions: Permissions[] = ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION']
          await reqPermissionsFromUser(permissions, getContext(this) as common.UIAbilityContext)
          const res = await getCurrentLocation()
          console.log(JSON.stringify(res))
        })
        Row() {
          Image($r('app.media.icon_search'))
            .width(16)
            .height(16)
            .fillColor($r('app.color.text_color_placeholder'))
          Text('请输入')
            .margin({left: 5})
            .fontSize($r('app.float.font_size_large'))
            .fontColor($r('app.color.text_color_placeholder'))
        }
        .height(28)
        .padding({left: 20})
        .margin({left: 8})
        .layoutWeight(1)
        .backgroundColor('#fff')
        .borderRadius(14)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/SearchPage'
          })
        })
      }
      .width('100%')
      .height(42)

      Row() {
        ForEach(this.tips, (tip: Tip) => {
          Row() {
            Image(tip.icon)
              .width(16)
              .height(16)
            Text(tip.text)
              .margin({left: 3})
              .fontSize($r('app.float.font_size_small'))
              .fontColor('#fff')
          }
        }, (_: Tip, index: number) => index+'')
      }
      .width('100%')
      .height(36)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding({top: 0, right: 15, bottom: 0, left: 15})
    .backgroundColor($r('app.color.bg_primary'))
  }
}