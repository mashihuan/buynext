import { NavigationBar } from '../components/NavigationBar'
import { Bar } from '../view/chart/bar'
import { Lines } from '../view/chart/Line'
import { Pie } from '../view/chart/Pie'

@Entry
@Component
struct Chart {

  build() {
    Column() {
      NavigationBar({title: '图表'})
      Scroll() {
        Column({space: 10}) {
          Bar()
            .padding(5)
            .backgroundColor('#fff')
          Lines()
            .padding(5)
            .backgroundColor('#fff')
          Pie()
            .padding(5)
            .backgroundColor('#fff')
        }
        .padding({ right: 10, bottom: 54, left: 10, top: 10 })
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.bg_color_page'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}