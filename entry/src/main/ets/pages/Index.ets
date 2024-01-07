@Entry
@Component
struct Index {
  //声明式UI:状态驱动页面刷新
  @State message: string = 'Hello World'  //@State会同步修改的值渲染到页面

  build() {  //build()中写页面样式
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .fontColor('#36D')
          .onClick(() => {
            this.message = 'Hello ArkTs!'
          })

        //加载网络图片
        Image($r('app.media.icon'))
          .width(250)   //数值默认单位vp虚拟像素；仅指定图片宽度，高度会按照图片比例自动缩放
          .interpolation(ImageInterpolation.High)
      }
      .width('100%')   //Column():列(纵向排列)占比100%，表示列全部填充父控件
    }
    .height('100%')  //Row():行(横向排列)占比100%，表示表示行全部填充父控件
  }
}