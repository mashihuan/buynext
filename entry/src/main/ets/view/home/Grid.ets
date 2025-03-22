import { requestHomeCategory } from "../../api/Category"
import { BASE_URL } from "../../common/Config"
import { router } from "@kit.ArkUI"

interface IGridInfo {
  id?: number
  icon: ResourceStr
  name: ResourceStr
  type: 'page' | 'menu' | number
  path?: string
  auth?: boolean
}

@Component
export struct HomeGrid {
  @Consume currentIndex: number
  @Consume categoryId: number
  @State gridList: IGridInfo[] = [
    { icon: $r('app.media.category_calendar'), name: '每日签到', path: 'pages/IntegralPage', type: 'page' },
    { icon: $r('app.media.category_member'), name: '大会员', path: 'pages/Member', type: 'page' },
    { icon: $r('app.media.category_invite'), name: '邀请有礼', path: 'pages/Invite', type: 'page' },
    { icon: $r('app.media.category_menu'), name: '四季菜谱', type: 'menu' },
    { icon: $r('app.media.category_more'), name: '更多分类', type: 0, },
  ]

  aboutToAppear(): void {
    this.getCategoryList()
  }

  async getCategoryList() {
    const res = await requestHomeCategory<IGridInfo[], null>()
    const categoryList = res.data.categorys || []
    this.gridList = categoryList.concat(this.gridList)
  }

  build() {
    Grid() {
      ForEach(this.gridList, (grid: IGridInfo) => {
        GridItem(){
          Column({space: 10}) {
            Image(grid.type === 1 ? (BASE_URL + grid.icon) : grid.icon)
              .width(55)
              .height(56)
              .borderRadius(28)
            Text(grid.name)
              .fontSize($r('app.float.font_size'))
              .fontColor($r('app.color.text_color'))
          }
          .onClick(() => {
            if(grid.type === 'page') {
              return router.pushUrl({
                url: grid.path
              })
            }
            if(grid.type === 'menu') {
              return this.currentIndex = 2
            }
            if(grid.type === 0) {
              return this.currentIndex = 1
            }
            if(grid.type === 1) {
              this.categoryId = grid.id as number
              return this.currentIndex = 1
            }
          })
        }
      }, (grid: IGridInfo) => `${grid.name}`)
    }
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
    .rowsTemplate('1fr 1fr')
    .height(202)
    .padding({ top: 2, bottom: 2})
    .margin({top: 10, bottom: 10})
    .backgroundColor('#fff')
  }
}