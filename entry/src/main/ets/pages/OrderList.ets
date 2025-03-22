import { router } from '@kit.ArkUI'
import { NavigationBar } from '../components/NavigationBar'
import { ICallback } from '../utils/Types'
import { OrderListData } from '../view/orderlist/ListData'
import { GoodsItem, GoodsModel } from '../viewmodel/GoodsModel'
import { OrderGoodsItem, OrderGoodsModel } from '../viewmodel/OrderGoodsModel'
import { OrderItem, OrderModel, OrderStatus } from '../viewmodel/OrderModel'

interface IRouterParams {
  index: number
}

@Entry
@Component
struct OrderList {
  private controller: TabsController = new TabsController()
  @State @Watch('getOrderList') currentTabIndex: number = 0
  @State orderListArray: Array<OrderItem[]> = []

  aboutToAppear(): void {
    const params = router.getParams() as IRouterParams
    this.currentTabIndex = params?.index || 0

    this.getOrderList()
  }

  async getOrderList(callback?: ICallback) {
    let status: OrderStatus = this.currentTabIndex
    switch (this.currentTabIndex) {
      case 0:
        status = OrderStatus.ALL;
        break;
      case 1:
        status = OrderStatus.NO_PAY;
        break;
      case 2:
        status = OrderStatus.NO_DELIVERY;
        break;
      case 3:
        status = OrderStatus.NO_COMMENT;
        break;
    }
    const goodsList = await GoodsModel.query()
    let orderList: OrderItem[] = []
    if(status === 0) {
      orderList = await OrderModel.query()
    }else {
      orderList = await OrderModel.getByStatus(status)
    }
    const orderGoodsList = await OrderGoodsModel.query()
    orderList.forEach(async (order: OrderItem) => {
      orderGoodsList.forEach((orderGoods: OrderGoodsItem) => {
        const goods = goodsList.find((goods: GoodsItem) => goods.id === orderGoods.goods_id)
        if(goods) {
          orderGoods.goods = goods
        }
      })
      order.goodsList = orderGoodsList || []
      order.total_num = orderGoodsList.reduce((prev, cur) => {
        return prev + cur.num
      }, 0)
      order.total_price = orderGoodsList.reduce((prev, cur) => {
        return prev + cur.num * cur.price
      }, 0)
    })
    this.orderListArray[status] = orderList
    if(callback) {
      callback()
    }
  }

  @Builder tabBarBuilder(text: string, index: number) {
    Column() {
      Text(text)
        .height('100%')
        .padding({right: 10, left: 10})
        .fontSize($r('app.float.font_size'))
        .fontColor($r('app.color.text_color'))
        .border({color: this.currentTabIndex === index ? $r('app.color.color_primary') : 'transparent', width: {bottom: 2}})
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#fff')
    .shadow(ShadowStyle.OUTER_DEFAULT_MD)
  }

  build() {
    Column() {
      NavigationBar({title: '我的订单'})
      Tabs({controller: this.controller, index: this.currentTabIndex}) {
        TabContent() {
          OrderListData({orderList: this.orderListArray[0], getOrderList: (callback: ICallback) => {
            this.getOrderList(callback)
          }})
        }
        .tabBar(this.tabBarBuilder('全部', 0))
        TabContent() {
          OrderListData({orderList: this.orderListArray[1], getOrderList:(callback: ICallback) => {
            this.getOrderList(callback)
          }})
        }
        .tabBar(this.tabBarBuilder('待付款', 1))
        TabContent() {
          OrderListData({orderList: this.orderListArray[2], getOrderList:(callback: ICallback) => {
            this.getOrderList(callback)
          }})
        }
        .tabBar(this.tabBarBuilder('待收货', 2))
        TabContent() {
          OrderListData({orderList: this.orderListArray[3], getOrderList:(callback: ICallback) => {
            this.getOrderList(callback)
          }})
        }
        .tabBar(this.tabBarBuilder('待评价', 3))
      }
      .barHeight(46)
      .divider({
        strokeWidth: 1,
        color: $r('app.color.border_color'),
        startMargin: 0,
        endMargin: 0
      })
      .onAnimationStart((_: number, targetIndex: number) => {
        setTimeout(() => {
          this.currentTabIndex = targetIndex
        }, 100)
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}