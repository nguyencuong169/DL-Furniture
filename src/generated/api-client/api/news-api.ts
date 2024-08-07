/* tslint:disable */
/* eslint-disable */
/**
 * DL-Furniture Web API
 * DL-Furniture の Web API 仕様
 *
 * The version of the OpenAPI document: 1.0.0
 *
 *
 * NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
 * https://openapi-generator.tech
 * Do not edit the class manually.
 */

import globalAxios, { AxiosPromise, AxiosInstance, AxiosRequestConfig } from 'axios'
import { Configuration } from '../configuration'
// Some imports not used depending on template conditions
// @ts-ignore
import {
  DUMMY_BASE_URL,
  assertParamExists,
  setApiKeyToObject,
  setBasicAuthToObject,
  setBearerAuthToObject,
  setOAuthToObject,
  setSearchParams,
  serializeDataIfNeeded,
  toPathString,
  createRequestFunction
} from '../common'
// @ts-ignore
import { BASE_PATH, COLLECTION_FORMATS, RequestArgs, BaseAPI, RequiredError } from '../base'
// @ts-ignore
import { News } from '../models'
/**
 * NewsApi - axios parameter creator
 * @export
 */
export const NewsApiAxiosParamCreator = function (configuration?: Configuration) {
  return {
    /**
     *
     * @param {number} id
     * @param {*} [options] Override http request option.
     * @throws {RequiredError}
     */
    newsDelete: async (id: number, options: AxiosRequestConfig = {}): Promise<RequestArgs> => {
      // verify required parameter 'id' is not null or undefined
      assertParamExists('newsDelete', 'id', id)
      const localVarPath = `/api/news/{id}`.replace(`{${'id'}}`, encodeURIComponent(String(id)))
      // use dummy base URL string because the URL constructor only accepts absolute URLs.
      const localVarUrlObj = new URL(localVarPath, DUMMY_BASE_URL)
      let baseOptions
      if (configuration) {
        baseOptions = configuration.baseOptions
      }

      const localVarRequestOptions = { method: 'DELETE', ...baseOptions, ...options }
      const localVarHeaderParameter = {} as any
      const localVarQueryParameter = {} as any

      setSearchParams(localVarUrlObj, localVarQueryParameter)
      let headersFromBaseOptions = baseOptions && baseOptions.headers ? baseOptions.headers : {}
      localVarRequestOptions.headers = {
        ...localVarHeaderParameter,
        ...headersFromBaseOptions,
        ...options.headers
      }

      return {
        url: toPathString(localVarUrlObj),
        options: localVarRequestOptions
      }
    },
    /**
     *
     * @param {number} id
     * @param {*} [options] Override http request option.
     * @throws {RequiredError}
     */
    newsGet: async (id: number, options: AxiosRequestConfig = {}): Promise<RequestArgs> => {
      // verify required parameter 'id' is not null or undefined
      assertParamExists('newsGet', 'id', id)
      const localVarPath = `/api/news/{id}`.replace(`{${'id'}}`, encodeURIComponent(String(id)))
      // use dummy base URL string because the URL constructor only accepts absolute URLs.
      const localVarUrlObj = new URL(localVarPath, DUMMY_BASE_URL)
      let baseOptions
      if (configuration) {
        baseOptions = configuration.baseOptions
      }

      const localVarRequestOptions = { method: 'GET', ...baseOptions, ...options }
      const localVarHeaderParameter = {} as any
      const localVarQueryParameter = {} as any

      setSearchParams(localVarUrlObj, localVarQueryParameter)
      let headersFromBaseOptions = baseOptions && baseOptions.headers ? baseOptions.headers : {}
      localVarRequestOptions.headers = {
        ...localVarHeaderParameter,
        ...headersFromBaseOptions,
        ...options.headers
      }

      return {
        url: toPathString(localVarUrlObj),
        options: localVarRequestOptions
      }
    },
    /**
     *
     * @param {*} [options] Override http request option.
     * @throws {RequiredError}
     */
    newsGetAll: async (options: AxiosRequestConfig = {}): Promise<RequestArgs> => {
      const localVarPath = `/api/news`
      // use dummy base URL string because the URL constructor only accepts absolute URLs.
      const localVarUrlObj = new URL(localVarPath, DUMMY_BASE_URL)
      let baseOptions
      if (configuration) {
        baseOptions = configuration.baseOptions
      }

      const localVarRequestOptions = { method: 'GET', ...baseOptions, ...options }
      const localVarHeaderParameter = {} as any
      const localVarQueryParameter = {} as any

      setSearchParams(localVarUrlObj, localVarQueryParameter)
      let headersFromBaseOptions = baseOptions && baseOptions.headers ? baseOptions.headers : {}
      localVarRequestOptions.headers = {
        ...localVarHeaderParameter,
        ...headersFromBaseOptions,
        ...options.headers
      }

      return {
        url: toPathString(localVarUrlObj),
        options: localVarRequestOptions
      }
    },
    /**
     *
     * @param {string} value
     * @param {*} [options] Override http request option.
     * @throws {RequiredError}
     */
    newsPost: async (value: string, options: AxiosRequestConfig = {}): Promise<RequestArgs> => {
      // verify required parameter 'value' is not null or undefined
      assertParamExists('newsPost', 'value', value)
      const localVarPath = `/api/news`
      // use dummy base URL string because the URL constructor only accepts absolute URLs.
      const localVarUrlObj = new URL(localVarPath, DUMMY_BASE_URL)
      let baseOptions
      if (configuration) {
        baseOptions = configuration.baseOptions
      }

      const localVarRequestOptions = { method: 'POST', ...baseOptions, ...options }
      const localVarHeaderParameter = {} as any
      const localVarQueryParameter = {} as any

      localVarHeaderParameter['Content-Type'] = 'application/json'

      setSearchParams(localVarUrlObj, localVarQueryParameter)
      let headersFromBaseOptions = baseOptions && baseOptions.headers ? baseOptions.headers : {}
      localVarRequestOptions.headers = {
        ...localVarHeaderParameter,
        ...headersFromBaseOptions,
        ...options.headers
      }
      localVarRequestOptions.data = serializeDataIfNeeded(
        value,
        localVarRequestOptions,
        configuration
      )

      return {
        url: toPathString(localVarUrlObj),
        options: localVarRequestOptions
      }
    },
    /**
     *
     * @param {number} id
     * @param {string} value
     * @param {*} [options] Override http request option.
     * @throws {RequiredError}
     */
    newsPut: async (
      id: number,
      value: string,
      options: AxiosRequestConfig = {}
    ): Promise<RequestArgs> => {
      // verify required parameter 'id' is not null or undefined
      assertParamExists('newsPut', 'id', id)
      // verify required parameter 'value' is not null or undefined
      assertParamExists('newsPut', 'value', value)
      const localVarPath = `/api/news/{id}`.replace(`{${'id'}}`, encodeURIComponent(String(id)))
      // use dummy base URL string because the URL constructor only accepts absolute URLs.
      const localVarUrlObj = new URL(localVarPath, DUMMY_BASE_URL)
      let baseOptions
      if (configuration) {
        baseOptions = configuration.baseOptions
      }

      const localVarRequestOptions = { method: 'PUT', ...baseOptions, ...options }
      const localVarHeaderParameter = {} as any
      const localVarQueryParameter = {} as any

      localVarHeaderParameter['Content-Type'] = 'application/json'

      setSearchParams(localVarUrlObj, localVarQueryParameter)
      let headersFromBaseOptions = baseOptions && baseOptions.headers ? baseOptions.headers : {}
      localVarRequestOptions.headers = {
        ...localVarHeaderParameter,
        ...headersFromBaseOptions,
        ...options.headers
      }
      localVarRequestOptions.data = serializeDataIfNeeded(
        value,
        localVarRequestOptions,
        configuration
      )

      return {
        url: toPathString(localVarUrlObj),
        options: localVarRequestOptions
      }
    }
  }
}

/**
 * NewsApi - functional programming interface
 * @export
 */
export const NewsApiFp = function (configuration?: Configuration) {
  const localVarAxiosParamCreator = NewsApiAxiosParamCreator(configuration)
  return {
    /**
     *
     * @param {number} id
     * @param {*} [options] Override http request option.
     * @throws {RequiredError}
     */
    async newsDelete(
      id: number,
      options?: AxiosRequestConfig
    ): Promise<(axios?: AxiosInstance, basePath?: string) => AxiosPromise<void>> {
      const localVarAxiosArgs = await localVarAxiosParamCreator.newsDelete(id, options)
      return createRequestFunction(localVarAxiosArgs, globalAxios, BASE_PATH, configuration)
    },
    /**
     *
     * @param {number} id
     * @param {*} [options] Override http request option.
     * @throws {RequiredError}
     */
    async newsGet(
      id: number,
      options?: AxiosRequestConfig
    ): Promise<(axios?: AxiosInstance, basePath?: string) => AxiosPromise<string>> {
      const localVarAxiosArgs = await localVarAxiosParamCreator.newsGet(id, options)
      return createRequestFunction(localVarAxiosArgs, globalAxios, BASE_PATH, configuration)
    },
    /**
     *
     * @param {*} [options] Override http request option.
     * @throws {RequiredError}
     */
    async newsGetAll(
      options?: AxiosRequestConfig
    ): Promise<(axios?: AxiosInstance, basePath?: string) => AxiosPromise<Array<News>>> {
      const localVarAxiosArgs = await localVarAxiosParamCreator.newsGetAll(options)
      return createRequestFunction(localVarAxiosArgs, globalAxios, BASE_PATH, configuration)
    },
    /**
     *
     * @param {string} value
     * @param {*} [options] Override http request option.
     * @throws {RequiredError}
     */
    async newsPost(
      value: string,
      options?: AxiosRequestConfig
    ): Promise<(axios?: AxiosInstance, basePath?: string) => AxiosPromise<void>> {
      const localVarAxiosArgs = await localVarAxiosParamCreator.newsPost(value, options)
      return createRequestFunction(localVarAxiosArgs, globalAxios, BASE_PATH, configuration)
    },
    /**
     *
     * @param {number} id
     * @param {string} value
     * @param {*} [options] Override http request option.
     * @throws {RequiredError}
     */
    async newsPut(
      id: number,
      value: string,
      options?: AxiosRequestConfig
    ): Promise<(axios?: AxiosInstance, basePath?: string) => AxiosPromise<void>> {
      const localVarAxiosArgs = await localVarAxiosParamCreator.newsPut(id, value, options)
      return createRequestFunction(localVarAxiosArgs, globalAxios, BASE_PATH, configuration)
    }
  }
}

/**
 * NewsApi - factory interface
 * @export
 */
export const NewsApiFactory = function (
  configuration?: Configuration,
  basePath?: string,
  axios?: AxiosInstance
) {
  const localVarFp = NewsApiFp(configuration)
  return {
    /**
     *
     * @param {number} id
     * @param {*} [options] Override http request option.
     * @throws {RequiredError}
     */
    newsDelete(id: number, options?: any): AxiosPromise<void> {
      return localVarFp.newsDelete(id, options).then((request) => request(axios, basePath))
    },
    /**
     *
     * @param {number} id
     * @param {*} [options] Override http request option.
     * @throws {RequiredError}
     */
    newsGet(id: number, options?: any): AxiosPromise<string> {
      return localVarFp.newsGet(id, options).then((request) => request(axios, basePath))
    },
    /**
     *
     * @param {*} [options] Override http request option.
     * @throws {RequiredError}
     */
    newsGetAll(options?: any): AxiosPromise<Array<News>> {
      return localVarFp.newsGetAll(options).then((request) => request(axios, basePath))
    },
    /**
     *
     * @param {string} value
     * @param {*} [options] Override http request option.
     * @throws {RequiredError}
     */
    newsPost(value: string, options?: any): AxiosPromise<void> {
      return localVarFp.newsPost(value, options).then((request) => request(axios, basePath))
    },
    /**
     *
     * @param {number} id
     * @param {string} value
     * @param {*} [options] Override http request option.
     * @throws {RequiredError}
     */
    newsPut(id: number, value: string, options?: any): AxiosPromise<void> {
      return localVarFp.newsPut(id, value, options).then((request) => request(axios, basePath))
    }
  }
}

/**
 * NewsApi - object-oriented interface
 * @export
 * @class NewsApi
 * @extends {BaseAPI}
 */
export class NewsApi extends BaseAPI {
  /**
   *
   * @param {number} id
   * @param {*} [options] Override http request option.
   * @throws {RequiredError}
   * @memberof NewsApi
   */
  public newsDelete(id: number, options?: AxiosRequestConfig) {
    return NewsApiFp(this.configuration)
      .newsDelete(id, options)
      .then((request) => request(this.axios, this.basePath))
  }

  /**
   *
   * @param {number} id
   * @param {*} [options] Override http request option.
   * @throws {RequiredError}
   * @memberof NewsApi
   */
  public newsGet(id: number, options?: AxiosRequestConfig) {
    return NewsApiFp(this.configuration)
      .newsGet(id, options)
      .then((request) => request(this.axios, this.basePath))
  }

  /**
   *
   * @param {*} [options] Override http request option.
   * @throws {RequiredError}
   * @memberof NewsApi
   */
  public newsGetAll(options?: AxiosRequestConfig) {
    return NewsApiFp(this.configuration)
      .newsGetAll(options)
      .then((request) => request(this.axios, this.basePath))
  }

  /**
   *
   * @param {string} value
   * @param {*} [options] Override http request option.
   * @throws {RequiredError}
   * @memberof NewsApi
   */
  public newsPost(value: string, options?: AxiosRequestConfig) {
    return NewsApiFp(this.configuration)
      .newsPost(value, options)
      .then((request) => request(this.axios, this.basePath))
  }

  /**
   *
   * @param {number} id
   * @param {string} value
   * @param {*} [options] Override http request option.
   * @throws {RequiredError}
   * @memberof NewsApi
   */
  public newsPut(id: number, value: string, options?: AxiosRequestConfig) {
    return NewsApiFp(this.configuration)
      .newsPut(id, value, options)
      .then((request) => request(this.axios, this.basePath))
  }
}
