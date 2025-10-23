import { get, put } from './request'
import { api_step } from '../api'
import { AppKeyHerder, MasterHerder } from '../common/RequestHeader'

export function getStepList(): Promise<string> {
  return get(api_step, AppKeyHerder)
}