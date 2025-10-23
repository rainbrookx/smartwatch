import { McBarChart, Options } from '@mcui/mccharts'
import { StepData, StepResponse } from '../typing'
import { getStepList } from '../http/fyx_request'

@Entry
@Component
export default struct StepStatistics {
  @State stepData: StepData[] = []
  @State totalSteps: number = 0
  @State dateRange: string = ''
  @State defOption: Options = new Options({
    title: {
      show: false,
    },
    xAxis: {
      data: [],
      axisLabel: {
        // x轴文本标签样式
        fontSize: 30,
        overflow: 'truncate',
      },
    },
    yAxis: {
      axisLabel: {
        fontSize: 30,
        overflow: 'truncate',
        // x轴文本标签样式
        formatter: (name: string,
          index: number) => { // 自定义文本标签
          return (parseInt(name) / 100).toFixed() + 'k'
        }
      }
    },
    series: [
      {
        data: []
      }
    ],
    legend: {
      show: false
    }
  })

  aboutToAppear() {
    this.fetchStepData()
  }

  // 获取步数数据
  async fetchStepData() {
    const rs = await getStepList()
    console.log('步数结果：', rs)

    const data: StepResponse = JSON.parse(rs)
    if (data.results && data.results.length > 0) {
      this.stepData = data.results[0].step_log
      this.calculateStatistics()
      this.updateDateRange()
      this.updateDefOption()
    }
  }

  // 计算统计数据
  calculateStatistics() {
    // 计算总数
    this.totalSteps = this.stepData.reduce((p: number, c: StepData) => p + c.steps, 0)
  }

  // 更新日期范围
  updateDateRange() {
    if (this.stepData.length === 0) {
      return;
    }
    const firstDate = this.stepData[0].date;
    const lastDate = this.stepData[this.stepData.length - 1].date;
    this.dateRange = `${firstDate.replace('-', '.')}-${lastDate.replace('-', '.')}`;
  }

  // 给统计图添加数据
  updateDefOption() {
    if (this.stepData.length === 0) {
      return;
    }
    const xAxisData = this.stepData.map((it: StepData) => it.date.slice(5).replace('-', '.'))
    const seriesData = this.stepData.map((it: StepData) => it.steps)

    this.defOption.setVal({
      xAxis: {
        data: xAxisData
      },
      series: [
        {
          data: seriesData
        }
      ],
    })
  }

  build() {
    Column() {
      // 日周月
      Row() {
        this.TabItem('日')
        this.TabItem('周')
        this.TabItem('月')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)

      // 日期
      Row() {
        Image($r('app.media.date_left')).width(14).height(14)
        Text(this.dateRange).margin({ left: 50, right: 50 })
          .fontSize(14)
          .fontColor('#666666')
        Image($r('app.media.date_right')).width(14).height(14)
      }.margin({ top: 20 })

      // 累计
      Column() {
        Text('累计').width('100%').padding({ left: 30, top: 30 })
        Text() {
          Span(this.totalSteps.toString()).font({ size: 50 })
          Span('  ')
          Span('步').fontSize(20)
        }
        .width('100%').padding({ left: 30, top: 10 })
      }

      // 统计图
      Row() {
        McBarChart({
          options: this.defOption
        })
      }
      .height('60%')
    }
  }

  @Builder
  TabItem(text: string) {
    Column() {
      Text(text)
        .fontSize(16).fontColor(text === '周' ? '#5B5FEF' : '#999999').fontWeight(FontWeight.Medium)

      Row()
        .width(24).height(3).margin({ top: 3 })
        .backgroundColor(text === '周' ? '#5B5FEF' : 'transparent')
    }
  }
}

