@Entry
@Component
struct HeartRatePage {
  @State currentTab: number = 0 // 0:日, 1:周, 2:月
  @State currentHeartRate: number = 86
  @State maxHeartRate: number = 98
  @State minHeartRate: number = 60
  @State currentDate: string = '今日，10月6日'

  // 模拟心率数据（24小时）
  @State heartRateData: number[] = [70, 75, 98, 85, 94, 82, 78, 72, 68, 65, 70, 75, 80, 85, 90, 88, 85, 80, 75, 70, 68, 65, 60, 62]

  // 选中的数据点
  @State selectedPointIndex: number = 4
  @State selectedPointValue: number = 94
  @State selectedPointTime: string = '2018年10月12日13:20'

  build() {
    Column() {
      // 顶部时间维度选择器
      Row() {
        this.TabButton('日', 0)
        this.TabButton('周', 1)
        this.TabButton('月', 2)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .padding({ top: 20, bottom: 10 })

      // 日期导航
      Row() {
        Image($r('sys.symbol.chevron_left'))
          .width(20)
          .height(20)
          .fillColor('#999999')
          .onClick(() => {
            console.log('上一天')
          })

        Text('今日')
          .fontSize(16)
          .fontColor('#333333')
          .margin({ left: 10, right: 10 })

        Image($r('sys.symbol.chevron_right'))
          .width(20)
          .height(20)
          .fillColor('#999999')
          .onClick(() => {
            console.log('下一天')
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .padding({ top: 10, bottom: 20 })

      // 当前日期
      Text(this.currentDate)
        .fontSize(14)
        .fontColor('#999999')
        .width('90%')
        .margin({ bottom: 10 })

      // 当前心率显示
      Row() {
        Text(this.currentHeartRate + 'bpm')
          .fontSize(60)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')

        Blank()

        Button('测试')
          .fontSize(16)
          .fontColor('#FF6B6B')
          .backgroundColor('#FFF5F5')
          .borderRadius(20)
          .padding({ left: 20, right: 20, top: 8, bottom: 8 })
          .onClick(() => {
            // 模拟测试心率
            this.currentHeartRate = Math.floor(Math.random() * 40) + 60
          })
      }
      .width('90%')
      .alignItems(VerticalAlign.Center)
      .margin({ bottom: 30 })

      // 最高和最低心率
      Row() {
        Column() {
          Text(this.maxHeartRate + 'bpm')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
          Text('最高')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 5 })
        }
        .alignItems(HorizontalAlign.Start)

        Blank()

        Column() {
          Text(this.minHeartRate + 'bpm')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
          Text('最低')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 5 })
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width('90%')
      .margin({ bottom: 30 })

      // 心率折线图
      Column() {
        Canvas(this.context)
          .width('100%')
          .height(300)
          .onReady(() => {
            this.drawChart()
          })
      }
      .width('90%')

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  @Builder TabButton(text: string, index: number) {
    Column() {
      Text(text)
        .fontSize(16)
        .fontColor(this.currentTab === index ? '#333333' : '#999999')
        .fontWeight(this.currentTab === index ? FontWeight.Medium : FontWeight.Normal)
        .onClick(() => {
          this.currentTab = index
        })

      // 下划线
      if (this.currentTab === index) {
        Divider()
          .width(20)
          .strokeWidth(2)
          .color('#1E90FF')
          .margin({ top: 5 })
      }
    }
  }

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))

  drawChart() {
    // 清空画布
    this.context.clearRect(0, 0, 400, 300)

    const padding = 40
    const chartWidth = 350
    const chartHeight = 200
    const startX = padding
    const startY = padding

    // 找出最大最小值
    const maxValue = Math.max(...this.heartRateData)
    const minValue = Math.min(...this.heartRateData)
    const valueRange = maxValue - minValue

    // 绘制背景区域（浅粉色）
    this.context.fillStyle = '#FFF0F0'
    this.context.beginPath()
    this.context.moveTo(startX, startY + chartHeight)

    for (let i = 0; i < this.heartRateData.length; i++) {
      const x = startX + (i / (this.heartRateData.length - 1)) * chartWidth
      const y = startY + chartHeight - ((this.heartRateData[i] - minValue) / valueRange) * chartHeight
      this.context.lineTo(x, y)
    }

    this.context.lineTo(startX + chartWidth, startY + chartHeight)
    this.context.closePath()
    this.context.fill()

    // 绘制折线
    this.context.strokeStyle = '#FF6B6B'
    this.context.lineWidth = 2
    this.context.beginPath()

    for (let i = 0; i < this.heartRateData.length; i++) {
      const x = startX + (i / (this.heartRateData.length - 1)) * chartWidth
      const y = startY + chartHeight - ((this.heartRateData[i] - minValue) / valueRange) * chartHeight

      if (i === 0) {
        this.context.moveTo(x, y)
      } else {
        this.context.lineTo(x, y)
      }
    }
    this.context.stroke()

    // 绘制数据点
    for (let i = 0; i < this.heartRateData.length; i++) {
      const x = startX + (i / (this.heartRateData.length - 1)) * chartWidth
      const y = startY + chartHeight - ((this.heartRateData[i] - minValue) / valueRange) * chartHeight

      // 空心圆点
      this.context.beginPath()
      this.context.arc(x, y, 4, 0, 2 * Math.PI)
      this.context.fillStyle = '#FFFFFF'
      this.context.fill()
      this.context.strokeStyle = '#FF6B6B'
      this.context.lineWidth = 2
      this.context.stroke()
    }

    // 绘制选中点的提示
    const selectedX = startX + (this.selectedPointIndex / (this.heartRateData.length - 1)) * chartWidth
    const selectedY = startY + chartHeight - ((this.heartRateData[this.selectedPointIndex] - minValue) / valueRange) * chartHeight

    // 垂直虚线
    this.context.setLineDash([5, 5])
    this.context.strokeStyle = '#CCCCCC'
    this.context.lineWidth = 1
    this.context.beginPath()
    this.context.moveTo(selectedX, startY)
    this.context.lineTo(selectedX, startY + chartHeight)
    this.context.stroke()
    this.context.setLineDash([])

    // 选中点
    this.context.beginPath()
    this.context.arc(selectedX, selectedY, 6, 0, 2 * Math.PI)
    this.context.fillStyle = '#FF6B6B'
    this.context.fill()

    // 提示框
    this.context.fillStyle = '#FFFFFF'
    this.context.strokeStyle = '#EEEEEE'
    this.context.lineWidth = 1
    const tooltipX = selectedX + 20
    const tooltipY = selectedY - 40
    this.context.fillRect(tooltipX, tooltipY, 140, 40)
    this.context.strokeRect(tooltipX, tooltipY, 140, 40)

    // 提示文字
    this.context.fillStyle = '#999999'
    this.context.font = '10px sans-serif'
    this.context.fillText(this.selectedPointTime, tooltipX + 5, tooltipY + 15)

    this.context.fillStyle = '#FF6B6B'
    this.context.font = 'bold 14px sans-serif'
    this.context.fillText(this.selectedPointValue + 'bpm', tooltipX + 5, tooltipY + 32)

    // 绘制X轴标签（时间）
    this.context.fillStyle = '#999999'
    this.context.font = '10px sans-serif'
    const timeLabels = ['3时', '6时', '9时', '12时', '15时', '18时', '21时', '24时']
    for (let i = 0; i < timeLabels.length; i++) {
      const x = startX + (i / (timeLabels.length - 1)) * chartWidth
      this.context.fillText(timeLabels[i], x - 10, startY + chartHeight + 20)
    }
  }
}

