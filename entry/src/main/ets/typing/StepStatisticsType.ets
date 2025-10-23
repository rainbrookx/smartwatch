// 步数数据接口定义
export interface StepData {
  date: string;
  steps: number;
}

export interface StepResult {
  step_log: StepData[];
  objectId: string;
  createdAt: string;
  updatedAt: string;
}

export interface StepResponse {
  results: StepResult[];
}