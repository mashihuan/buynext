import { Empty } from "../../components/Empty";
import { OrderGoodsItem } from "../../viewmodel/OrderGoodsModel";
import { OrderItem } from "../../viewmodel/OrderModel";
import { promptAction } from "@kit.ArkUI";
import { BASE_URL } from "../../common/Config";
import { ICallback } from "../../utils/Types";
import {PullToRefresh, refreshConfigurator } from '../../utils/PullToRefreshUtil';

@Extend(Text) function statusStyle() {
  .width('100%')
  .textAlign(TextAlign.End)
  .fontSize(14)
  .fontColor($r('app.color.price_color_new'))
}

@Extend(Button) function btnStyle() {
  .type(ButtonType.Normal)
  .height(30)
  .fontSize(13)
  .borderRadius(10)
  .backgroundColor($r('app.color.color_danger'))
}

@Component
export struct OrderListData {
  @Prop orderList: OrderItem[] = []
  getOrderList: (callback: ICallback) => void = () => {}
  private scroller: Scroller = new Scroller()

  @Builder getListView() {
    Scroll(this.scroller) {
      Column() {
        if(this.orderList.length) {
          Column() {
            ForEach(this.orderList, (order: OrderItem) => {
              Column({space: 10}) {
                if(order.status === 1) {
                  Text('待支付')
                    .statusStyle()
                }
                if(order.status === 2) {
                  Text('待收货')
                    .statusStyle()
                }
                if(order.status === 3) {
                  Text('待评价')
                    .statusStyle()
                }
                ForEach(order.goodsList, (orderGoods: OrderGoodsItem) => {
                  Row({space: 15}) {
                    Image(BASE_URL + orderGoods.goods?.icon)
                      .width(70)
                      .height(70)
                      .objectFit(ImageFit.Cover)
                    Column() {
                      Text(orderGoods.goods?.desc)
                        .width('100%')
                        .fontSize($r('app.float.font_size'))
                        .fontColor($r('app.color.text_color'))
                        .lineHeight(20)
                        .maxLines(2)
                        .textOverflow({overflow: TextOverflow.Ellipsis})
                      Row() {
                        Text(`￥${orderGoods.goods?.new_price.toFixed(1)}`)
                          .fontSize($r('app.float.font_size'))
                          .fontColor($r('app.color.price_color_new'))
                        Text(`x${orderGoods.num}`)
                          .fontSize($r('app.float.font_size'))
                          .fontColor($r('app.color.text_color_lighter'))
                      }
                      .justifyContent(FlexAlign.SpaceBetween)
                      .width('100%')
                    }
                    .layoutWeight(1)
                    .height(70)
                    .justifyContent(FlexAlign.SpaceBetween)
                  }
                  .width('100%')
                }, (orderGoods: OrderGoodsItem) => `${orderGoods.id}`)
                Row() {
                  Text(`共${order.total_num}件商品，合计：${order.total_price.toFixed(1)}元`)
                    .fontSize($r('app.float.font_size'))
                    .fontColor($r('app.color.text_color'))
                }
                .width('100%')
                .justifyContent(FlexAlign.End)
                Row() {
                  if(order.status === 1) {
                    Button('去支付')
                      .btnStyle()
                      .onClick(() => promptAction.showToast({message: '点击了去支付'}))
                  }
                  if(order.status === 2) {
                    Button('确认收货')
                      .btnStyle()
                      .onClick(() => promptAction.showToast({message: '点击了确认收货'}))
                  }
                  if(order.status === 3) {
                    Button('去评价')
                      .btnStyle()
                      .onClick(() => promptAction.showToast({message: '点击了去评价'}))
                  }
                }
                .width('100%')
                .justifyContent(FlexAlign.End)
              }
              .width('100%')
              .backgroundColor('#fff')
              .padding(15)
              .margin({top: 10})
            }, (order: OrderItem) => `${order.id}`)
          }
        }else {
          Empty({desc: '暂无此类订单...'})
        }
      }
    }
  }

  build() {
    Column() {
      PullToRefresh({
        // 必传项，列表组件所绑定的数据
        data: $orderList,
        // 必传项，需绑定传入主体布局内的列表或宫格组件
        scroller: this.scroller,
        // 必传项，自定义主体布局，内部有列表或宫格组件
        refreshConfigurator: refreshConfigurator,
        customList: () => {
          // 一个用@Builder修饰过的UI方法
          this.getListView();
        },
        // 可选项，下拉刷新回调
        onRefresh: () => {
          return new Promise<string>((resolve) => {
            // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
            console.log('下拉刷新')
            this.getOrderList(() => {})
            resolve('刷新成功');
          });
        },
        // 可选项，上拉加载更多回调
        onLoadMore: () => {
          return new Promise<string>((resolve) => {
            // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
            setTimeout(() => {
              console.log('上拉加载')
              resolve('上拉加载');
            }, 2000)
          });
        },
        customLoad: null,
        customRefresh: null,
      })
    }
    .width('100%')
    .height('100%')
    .padding({bottom: 44})
  }
}