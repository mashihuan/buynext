import { NavigationBar } from "../../components/NavigationBar"
import { MineCoupon } from "./Coupon"
import { MineOrder } from "./Order"
import { MineProfile } from "./Profile"
import { MineTools } from "./Tools"
import { router } from "@kit.ArkUI"

@Component
export struct MineIndex {
  build() {
    Column() {
      NavigationBar({
        title: '个人中心',
        hiddenBack: true,
        rightIcon: $r('app.media.icon_notice'),
        clickRight: () => {
          router.pushUrl({
            url: 'pages/Message'
          })
        }
      })
      MineProfile()
      Column() {
        MineCoupon()
        MineOrder()
        MineTools()
      }
      .padding({right: 16, left: 16})
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}