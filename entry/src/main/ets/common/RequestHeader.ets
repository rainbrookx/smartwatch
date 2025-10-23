import { HerderType } from '../typing'

const appId = "whkhvpIFnL17y93QUN8vtr8X-gzGzoHsz"
const appKey = "o2Hf1iAV3fzoQdZPq76B0k9I"
const masterKey = "fKgJrldI3qQDCP6mX5RcGxDT"
const contentType = "application/json"

export const AppKeyHerder: HerderType = {
  "X-LC-Id": appId,
  "X-LC-Key": appKey,
  "Content-Type": contentType
}

export const MasterHerder: HerderType = {
  "X-LC-Id": appId,
  "X-LC-Key": masterKey + ",master",
  "Content-Type": contentType
}