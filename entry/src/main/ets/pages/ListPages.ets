class Item {
  name: string
  image: ResourceStr
  price: number
  discount: number

  constructor(name: string, image: ResourceStr, price: number, discount: number = 0) {
    this.name = name
    this.image = image
    this.price = price
    this.discount = discount
  }
}

//导入Header, ../ 表示上一级目录
import {Header} from '../componts/CommonComponts'

//全局自定义构建函数
/*@Builder function ItemCard(item: Item) {
  Row({ space: 10 }) {   //ListItem里面只能有一个根组件，所以需要用Row包装一下
    Image(item.image)
      .width(100)
    Column({ space: 4 }) {
      if (item.discount) { //条件控制：有折扣
        Text(item.name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Text('原价：￥ ' + item.price)
          .fontColor('#CCC')
          .fontSize(14)
          .decoration({type: TextDecorationType.LineThrough})  //中划线
        Text('折扣价：￥ ' + (item.price - item.discount))
          .fontColor('#F36')
          .fontSize(18)
        Text('补贴：￥ ' + item.discount)
          .fontColor('#F36')
          .fontSize(18)
      } else {
        Text(item.name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Text('￥ ' + item.price)
          .fontColor('#CCC')
          .fontSize(14)
      }
    }
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }
  .width('100%')
  .backgroundColor('#FFF')
  .borderRadius(20)
  .height(120)
  .padding(10)
}*/

//全局自定义公共样式
/*@Styles function fillScreen() {
  .width('100%')
  .height('100%')
  .backgroundColor('#EFEFEF')
  .padding(20)
}*/

//@Extend(组件名): 标识组件特有属性
@Extend(Text) function priceText() {
  .fontColor('#F36')
  .fontSize(18)
}

@Entry
@Component
struct ItemPage {

  // 商品数据
  private items: Array<Item> = [
    new Item('华为Mate60', $r('app.media.mate60'), 6999, 500),
    new Item('MateBookProX', $r('app.media.mateBookProX'), 13999),
    new Item('WatchGT4', $r('app.media.watchGT4'), 1438),
    new Item('FreeBuds Pro3', $r('app.media.freeBudsPro3'), 1499),
    new Item('FreeBuds Pro3', $r('app.media.freeBudsPro3'), 1499),
    new Item('Mate X5', $r('app.media.mateX5'), 12999)
  ]

  //局部自定义公共样式
  @Styles fillScreen() {
    .width('100%')
    .height('100%')
    .backgroundColor('#EFEFEF')
    .padding(20)
  }

  build() {
    Column({ space: 8 }) {
      Header({title: '商品列表'})  //title传参
        .margin({ bottom: 20 })   //对自定义组件加外边距
        .backgroundColor('#FDF')

      /**
       * 列表
       */
      List({space:8}) {  //每行间距
        ForEach(
          this.items,
          (item: Item) => {
            ListItem() {   //ListItem
              this.ItemCard(item)
            }
          }
        )
      }
      .width('100%')
      .layoutWeight(1)   //按权重设置高度: 因为这里只有List设置了1，它就占剩余高度; 如果也有其他控件设置了1，则平分高度
    }
    .fillScreen()
  }

  //局部自定义构建函数
  @Builder ItemCard(item: Item) {
    Row({ space: 10 }) {   //*ListItem里面只能有一个根组件，所以需要用Row包装一下
      Image(item.image)
        .width(100)
      Column({ space: 4 }) {
        if (item.discount) { //条件控制：有折扣
          Text(item.name)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Text('原价：￥ ' + item.price)
            .fontColor('#CCC')
            .fontSize(14)
            .decoration({type: TextDecorationType.LineThrough})  //中划线
          Text('折扣价：￥ ' + (item.price - item.discount))
            .priceText()
          Text('补贴：￥ ' + item.discount)
            .priceText()
        } else {
          Text(item.name)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Text('￥ ' + item.price)
            .priceText()
        }
      }
      .height('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .backgroundColor('#FFF')
    .borderRadius(20)
    .height(120)
    .padding(10)
  }
}