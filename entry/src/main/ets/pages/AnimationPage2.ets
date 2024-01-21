import router from '@ohos.router'
import curves from '@ohos.curves'

@Entry
@Component
struct AnimationPage2 {
  // 小鱼坐标
  @State fishX: number = 200
  @State fishY: number = 180
  // 小鱼角度
  @State angle: number = 0
  // 小鱼图片
  @State src: Resource = $r('app.media.fish')

  // 是否开始游戏
  @State isBegin: boolean = false

  // 摇杆中心区域坐标：因为摇杆的宽、高是240、240
  private centerX: number = 120
  private centerY: number = 120

  // 大、小圆半径
  private maxRadius: number = 100
  private radius: number = 20

  // 摇杆小圆球初始位置
  @State positionX: number = this.centerX;
  @State positionY: number = this.centerY;

  // 角度正弦和余弦
  sin: number = 0
  cos: number = 0

  // 小鱼移动速度
  speed: number = 0
  // 任务id
  taskId: number = -1

  build() {
    Row() {
      Stack() {
        // 返回按钮
        Button('返回')
          .position({ x: 0, y: 0 })
          .backgroundColor('#20101010')
          .onClick(() => {
            // 返回上一页
            router.back()
          })

        if (!this.isBegin) {
          // 开始按钮
          Button('开始游戏')
            .onClick(() => {
              //转场动画需要把显示的动作放入animateTo中
              animateTo(
                { duration: 1000 },
                () => {
                  //点击后显示小鱼
                  this.isBegin = true
                }
              )
            })
        } else {
          // 小鱼图片
          Image(this.src)
            .position({ x: this.fishX - 20, y: this.fishY - 20 })
            .rotate({ angle: this.angle, centerX: '50%', centerY: '50%' })
            .width(40)
            .height(40)
              // .animation({duration: 500})   //属性动画
            .transition({ //转场动画，这里只考虑入场
              type: TransitionType.Insert,
              opacity: 0, //透明度。0:透明，看不见
              translate: { x: -250 } //小鱼起点在屏幕外
            })
        }
        // 摇杆按钮
        Row() {
          Circle({ width: this.maxRadius * 2, height: this.maxRadius * 2 })
            .fill('#20101010')
            .position({
              x: this.centerX - this.maxRadius,
              y: this.centerY - this.maxRadius
            }) //-this.maxRadius是为了通过中心点找到左上角位置
          Circle({ width: this.radius * 2, height: this.radius * 2 })
            .fill('#403A3A3A')
            .position({ x: this.positionX - this.radius, y: this.positionY - this.radius })
        }
        .onTouch(this.handleTouchEvent.bind(this)) //按下不松手事件onTouch
        .height(240)
        .width(240)
        .justifyContent(FlexAlign.Center) //主轴居中对齐
        .position({ x: 0, y: 120 }) //主轴左上角位置
      }
      .width('100%').height('100%')
    }
    .height('100%')
    .width('100%')
    .backgroundImage($r('app.media.sea'))
    .backgroundImageSize({ height: '105%', width: '100%' })
  }

  /**
   * 处理手指移动事件
   */
  handleTouchEvent(event: TouchEvent) {
    //不同事件不同处理
    switch (event.type) {
      case TouchType.Up: //手指松开
        // 还原小鱼速度和角度
        this.speed = 0
        this.angle = 0
        // 取消定时任务
        clearInterval(this.taskId)
        animateTo({
          curve: curves.springMotion()   //还原动效
        }, () => {
          // 还原摇杆小球的坐标
          this.positionX = this.centerX
          this.positionY = this.centerY
        })
        break
      case TouchType.Down: //手指按下
        // 开始定时任务: 使用定时任务是为了让小鱼移动具有连贯性(小鱼的移动用定时任务快速播放代替了动画)
        this.taskId = setInterval(() => {
          this.fishX += this.speed * this.cos
          this.fishY += this.speed * this.sin
        }, 40)   //40ms -> 25帧/s
        break
      case TouchType.Move: //手指移动
      // 1.获取手指位置坐标
        let x = event.touches[0].x //screenX/Y：触控在屏幕坐标；x/y:触控在当前容器(Row)内坐标
        let y = event.touches[0].y
      // 2.计算手指与中心点的坐标差值
        let vx = x - this.centerX
        let vy = y - this.centerY
      // 3.计算手指与中心点连线和x轴正半轴的夹角，单位是弧度
        let angle = Math.atan2(vy, vx) //计算夹角(返回是弧度不是角度)
      // 4.计算手指与中心点的距离(区分手指在摇杆内部和外部)
        let distance = this.getDistance(vx, vy)
        this.sin = Math.sin(angle)
        this.cos = Math.cos(angle)
        animateTo({
          curve: curves.responsiveSpringMotion() //持续跟手
        }, () => {
          // 5.计算摇杆小球的坐标
          this.positionX = this.centerX + distance * this.cos
          this.positionY = this.centerY + distance * this.sin
          // 6.计算小鱼坐标和角度
          this.speed = 5
          // this.fishX += this.speed * this.cos
          // this.fishY += this.speed * this.sin
          if (Math.abs(angle * 2) < Math.PI) {  //弧度<pi/2即角度<90；小鱼处于(-90~90)即正向
            this.src = $r('app.media.fish')
          } else {
            this.src = $r('app.media.fish_rev')
            angle = angle < 0 ? angle + Math.PI : angle - Math.PI  //图片反转时角度也反转
          }
          //小鱼角度判断详见 media/animate_angle_fish_rotate：顺指针旋转0~180,逆时针旋转0~(-180)；小鱼需要反转图片是90~180和(-90)~(-180)
          this.angle = angle * 180 / Math.PI  //弧度转角度 *180/pi
        })
      //上述计算详见图示 media/animate_angle_calculate.png
        break
    }
  }

  getDistance(x: number, y: number) {
    let d = Math.sqrt(x * x + y * y)
    return Math.min(d, this.maxRadius) //不能超过大圆半径
  }
}