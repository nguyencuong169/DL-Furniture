import { defineStore } from 'pinia'

export const bookingUseStore = defineStore('bookingStore', {
  state: () => ({
    isDisplay: true
  }),
  // getters: {
  //   // automatically infers the return type as a number
  //   displayState(state) {
  //     return state.isDisplay
  //   }
  // }
})
