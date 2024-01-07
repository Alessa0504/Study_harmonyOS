@Entry
@Component
struct Index {
  //声明式UI:状态驱动页面刷新
  @State imageWidth: number = 150  //@State会同步修改的值渲染到页面

  build() {  //build()中写页面样式
      Column() {
        Row(){
          //加载网络图片
          Image($r('app.media.icon'))
            .width(this.imageWidth)   //数值默认单位vp虚拟像素；仅指定图片宽度，高度会按照图片比例自动缩放
            .interpolation(ImageInterpolation.High)
        }
        .width('100%')
        .height(400)   //Row容器嵌套并固定高度放至影响下面的元素
        .justifyContent(FlexAlign.Center)  //Row主轴(水平)居中，默认左对齐

        Row() {
          Text($r("app.string.width_label"))
            .fontSize(20)  //lp虚拟像素单位
            .fontWeight(FontWeight.Bold)

          TextInput({
            placeholder:'请输入图片宽度',
            // text: '30'
            text:this.imageWidth.toFixed(0)   //默认值; toFixed(0):number转为string,0表示不需要小数点即为整数
          }).width(150)
            .backgroundColor('#FFF')
            .type(InputType.Number)  //限制输入的是数字格式
            .onChange((value: string) => {   //(value: string) => void
              console.log(value)   //输出日志
              this.imageWidth = parseInt(value)
            })
        }
        .width('100%')   //height不设置，让文本撑起高度
        .padding({  //内边距
          left:14,
          right:14
        })
        .justifyContent(FlexAlign.SpaceBetween)

        Divider()   //分割线
          .width('92%')

        Row() {
          Button('缩小')
            .width(80)
            .fontSize(20)
            .onClick(() => {
              if(this.imageWidth >= 10) {
                this.imageWidth -= 10
              }
            })

          Button('放大')
            .width(80)
            .fontSize(20)
              // .type(ButtonType.Normal)
            .onClick(() => {
              if(this.imageWidth < 300) {
                this.imageWidth += 10
              }
            })
        }
        .width('100%')
        .margin({   //外边距
          top: 35,
          bottom: 35
        })
        .justifyContent(FlexAlign.SpaceEvenly)

        Slider({     //自成一行，可无需容器
          min: 100,
          max: 300,
          value: this.imageWidth,  //初始化值，需要在min、max之间
          step: 10
        }).width('100%')
          .blockColor('#36D')   //滑块颜色
          .trackThickness(7)   //滑轨粗细
          .showTips(true)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.imageWidth = value  //滑动条的值改变影响到图片宽度
          })
      }
      .width('100%')   //Column():列(纵向排列)占比100%，表示列全部填充父控件
      .height('100%')  //Row():行(横向排列)占比100%，表示表示行全部填充父控件
  }
}