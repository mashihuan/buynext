import { Empty } from '../components/Empty'
import { NavigationBar } from '../components/NavigationBar'

@Entry
@Component
struct Message {
  build() {
    Column() {
      NavigationBar({title: '消息中心'})
      Empty({desc: '暂无消息...'})
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}