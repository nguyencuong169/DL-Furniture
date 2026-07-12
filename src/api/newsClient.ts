import { Configuration } from '../generated/api-client/configuration'
import { NewsApi } from '../generated/api-client/api'

const configuration = new Configuration({
  basePath: import.meta.env.VITE_API_BASE_URL || 'https://localhost:44328'
})

export const newsApi = new NewsApi(configuration)
